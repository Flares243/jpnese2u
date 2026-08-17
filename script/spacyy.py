import spacy
from spacy.matcher import Matcher
from spacy.tokens import Span
from spacy.util import filter_spans

nlp = spacy.load("ja_core_news_sm")
matcher = Matcher(nlp.vocab)

# Merge ONLY content stems + auxiliary verbs (助動詞)
verb_aux_pattern = [
    {"POS": {"IN": ["VERB", "ADJ", "NOUN", "PROPN"]}},
    {"TAG": {"REGEX": "^助動詞"}, "OP": "+"},
]

matcher.add("VERB_AUX_MERGE", [verb_aux_pattern])

doc = nlp(
    "あっ、しかし私のお友達たちは、あの静かな美しい公園でとても楽しそうに歌いました！"
)
matches = matcher(doc)

spans = [Span(doc, start, end, label=match_id) for match_id, start, end in matches]
filtered_spans = filter_spans(spans)

with doc.retokenize() as retokenizer:
    for span in filtered_spans:
        retokenizer.merge(span)

print([token.text for token in doc])