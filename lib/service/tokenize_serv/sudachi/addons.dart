import 'dart:io';

import 'package:jpnese2u/service/tokenize_serv/sudachi/model.dart';
import 'package:jpnese2u/util/app_dirent.dart';
import 'package:jpnese2u/util/constant/hinshi.dart';
import 'package:path/path.dart' as path;
import 'package:sudachi_dart/sudachi_dart.dart';

const kSudachiConfigFileName = 'sudachi.json';
const kSudachiDictionaryFileName = 'sudachi.dic';

extension SudachiAppDirentsExt on AppDirent {
  File get sudachiConfigFile => File(
    path.join(appSupportDir.path, kSudachiConfigFileName),
  );

  File get sudachiDictionaryFile => File(
    path.join(appSupportDir.path, kSudachiDictionaryFileName),
  );
}

extension MorphemeExt on List<Morpheme> {
  /// Merges Mode B morphemes into clean, syntactic predicate chunks
  /// based strictly on standard Japanese POS grammar rules.
  List<Morpheme> mergeJapanesePredicates() {
    final morphemes = this;
    if (morphemes.isEmpty) return [];

    final List<Morpheme> result = [];
    int i = 0;
    final int length = morphemes.length;

    // Primary POS tags that can initiate a predicate/stem chunk
    const baseHinshiTargets = <Hinshi>{
      Hinshi.verb,
      Hinshi.adjI,
      Hinshi.adjNa,
      Hinshi.noun,
      Hinshi.pronoun,
    };

    // Conjunctive particles that form copular conjunctions with 'だ'/'です' (e.g. 'だけど', 'だから')
    const copularConjunctionParticles = <String>{
      'けど',
      'けれど',
      'けれども',
      'から',
      'が',
    };

    // Tense, politeness, mood, negative, passive/causative, and attributive auxiliaries
    const inflectionalAuxiliaries = <String>{
      'まし',
      'ます',
      'ませ',
      'ましょう',
      'た',
      'たら',
      'たり',
      'だ',
      'です',
      'でし',
      'な',
      'ない',
      'なく',
      'なかっ',
      'なけれ',
      'たい',
      'たく',
      'たかっ',
      'たけれ',
      'ぬ',
      'ん',
      'ず',
      'う',
      'よう',
      'らしい',
      // Passive / Causative / Potential Auxiliaries (助動詞)
      'られ',
      'られる',
      'れ',
      'れる',
      'させ',
      'させる',
      'せ',
      'せる',
    };

    // Suru-verb inflections that attach to Nouns (サ変動詞)
    const suruVerbSurfaces = <String>{
      'する',
      'し',
      'できる',
      'され',
      'される',
      'させる',
      'させられる',
    };

    // Aspect subsidiary verbs that attach after 'て' / 'で'
    const teAspectVerbs = <String>{
      'いる',
      'ある',
      'おく',
      'しまう',
      'みる',
      'いく',
      'くる',
    };

    Hinshi? getPrimaryHinshi(Morpheme m) {
      if (m.partOfSpeech.isEmpty) return null;
      return Hinshi.fromJp(m.partOfSpeech[0]);
    }

    bool hasHinshi(Morpheme m, Hinshi target) {
      return m.partOfSpeech.any((posStr) => Hinshi.fromJp(posStr) == target);
    }

    // Check if current token starts a standalone copula chain
    // (e.g., 'だ' + 'けど' -> 'だけど', 'だっ' + 'た' -> 'だった', 'でし' + 'た' -> 'でした')
    bool isCopulaChainStart(int index) {
      final m = morphemes[index];
      final hinshi = getPrimaryHinshi(m);
      final bool isAux =
          hinshi == Hinshi.auxiliary || hasHinshi(m, Hinshi.auxiliary);
      if (!isAux || index + 1 >= length) return false;

      final nextSurf = morphemes[index + 1].surface;

      // 1. Past copula: 'だっ' + 'た', 'でし' + 'た'
      if ((m.surface == 'だっ' || m.surface == 'でし') && nextSurf == 'た') {
        return true;
      }
      // 2. Copular conjunction: 'だ' / 'です' + 'けど' / 'から' / 'が'
      if ((m.surface == 'だ' || m.surface == 'です') &&
          copularConjunctionParticles.contains(nextSurf)) {
        return true;
      }
      return false;
    }

    while (i < length) {
      final current = morphemes[i];
      final Hinshi? primaryHinshi = getPrimaryHinshi(current);

      final bool isCopulaStart = isCopulaChainStart(i);

      if ((primaryHinshi != null &&
              baseHinshiTargets.contains(primaryHinshi)) ||
          isCopulaStart) {
        final mergedSurface = StringBuffer(current.surface);
        final mergedReading = StringBuffer(current.readingForm);
        final mergedNormalized = StringBuffer(current.normalizedForm);
        
        int j = i + 1;

        // Track whether the current chain contains a verb or adjective stem
        bool hasVerbOrAdjStem =
            primaryHinshi == Hinshi.verb ||
            primaryHinshi == Hinshi.adjI ||
            primaryHinshi == Hinshi.adjNa;

        while (j < length) {
          final nextMorpheme = morphemes[j];
          final Hinshi? nextHinshi = getPrimaryHinshi(nextMorpheme);

          // RULE 1: Merge Inflectional Auxiliaries (助動詞)
          if ((nextHinshi == Hinshi.auxiliary ||
                  hasHinshi(nextMorpheme, Hinshi.auxiliary)) &&
              inflectionalAuxiliaries.contains(nextMorpheme.surface)) {
            // GUARD:
            // 1. Plain Nouns/Pronouns do NOT absorb 'だ'/'です'/'だっ'/'でし'
            // 2. Na-Adjectives stop absorbing IF followed by conjunction ('だけど') OR past copula ('だった')
            if (nextMorpheme.surface == 'だ' ||
                nextMorpheme.surface == 'です' ||
                nextMorpheme.surface == 'だっ' ||
                nextMorpheme.surface == 'でし') {
              final bool isNounOrPronoun =
                  primaryHinshi == Hinshi.noun ||
                  primaryHinshi == Hinshi.pronoun;
              final bool isFollowedByConjunction =
                  j + 1 < length &&
                  copularConjunctionParticles.contains(
                    morphemes[j + 1].surface,
                  );
              final bool isPastCopula =
                  (nextMorpheme.surface == 'だっ' ||
                      nextMorpheme.surface == 'でし') &&
                  j + 1 < length &&
                  morphemes[j + 1].surface == 'た';

              if (isNounOrPronoun ||
                  isFollowedByConjunction ||
                  (primaryHinshi == Hinshi.adjNa && isPastCopula)) {
                break; // Stop so stem stays standalone and copula chain merges on next pass
              }
            }

            mergedSurface.write(nextMorpheme.surface);
            mergedReading.write(nextMorpheme.readingForm);
            mergedNormalized.write(nextMorpheme.normalizedForm);
            j++;
          }
          // RULE 2: Merge Copular Chains (e.g., 'だ' + 'けど' -> 'だけど', 'だっ' + 'た' -> 'だった')
          else if (isCopulaStart &&
              (copularConjunctionParticles.contains(nextMorpheme.surface) ||
                  nextMorpheme.surface == 'た')) {
            mergedSurface.write(nextMorpheme.surface);
            mergedReading.write(nextMorpheme.readingForm);
            mergedNormalized.write(nextMorpheme.normalizedForm);
            j++;
            break; // Merged copula chain, done
          }
          // RULE 3: Merge Compound / Suru Verbs (動詞)
          else if (nextHinshi == Hinshi.verb) {
            final bool isSuruVerb = suruVerbSurfaces.contains(
              nextMorpheme.surface,
            );

            if (hasVerbOrAdjStem || isSuruVerb) {
              mergedSurface.write(nextMorpheme.surface);
              mergedReading.write(nextMorpheme.readingForm);
              mergedNormalized.write(nextMorpheme.normalizedForm);
              hasVerbOrAdjStem = true;
              j++;
            } else {
              break;
            }
          }
          // RULE 4: Te-Form Particle ('て' / 'で')
          else if (hasVerbOrAdjStem &&
              nextHinshi == Hinshi.particle &&
              (nextMorpheme.surface == 'て' || nextMorpheme.surface == 'で')) {
            mergedSurface.write(nextMorpheme.surface);
            mergedReading.write(nextMorpheme.readingForm);
            mergedNormalized.write(nextMorpheme.normalizedForm);
            j++;

            if (j < length) {
              final afterTeMorpheme = morphemes[j];
              if (teAspectVerbs.contains(afterTeMorpheme.surface)) {
                continue;
              }
            }
            break;
          }
          // RULE 5: Conditional Particle ('ば')
          else if (hasVerbOrAdjStem &&
              nextHinshi == Hinshi.particle &&
              nextMorpheme.surface == 'ば') {
            mergedSurface.write(nextMorpheme.surface);
            mergedReading.write(nextMorpheme.readingForm);
            mergedNormalized.write(nextMorpheme.normalizedForm);
            j++;
            break;
          } else {
            break;
          }
        }

        if (j > i + 1) {
          result.add(
            Morpheme(
              surface: mergedSurface.toString(),
              dictionaryForm: current.dictionaryForm,
              normalizedForm: mergedNormalized.toString(),
              readingForm: mergedReading.toString(),
              partOfSpeech: current.partOfSpeech,
            ),
          );
          i = j;
          continue;
        }
      }

      result.add(current);
      i++;
    }

    return result;
  }
}

SudachiConfig get sudachiBaseConfig => SudachiConfig(
  configPath: AppDirent.getInstance.sudachiConfigFile.path,
  dictionaryPath: AppDirent.getInstance.sudachiDictionaryFile.path,
);
