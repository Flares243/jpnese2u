import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocProviderBuilder<B extends StateStreamableSource<S>, S>
    extends StatelessWidget {
  const BlocProviderBuilder({
    super.key,
    required this.create,
    required this.builder,
  });

  final B Function(BuildContext context) create;
  final Widget Function(BuildContext context, S state) builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: create,
      child: BlocBuilder<B, S>(
        builder: builder,
      ),
    );
  }
}
