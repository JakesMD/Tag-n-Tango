import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tcore/core.dart';

final class MockBlocState with EquatableMixin {
  const MockBlocState(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

final class MockBlocEvent {}

class MockBloc extends Bloc<MockBlocEvent, MockBlocState> with EquatableMixin {
  MockBloc(this.id) : super(const MockBlocState('initial'));
  final String id;

  @override
  List<Object?> get props => [id];
}

void main() {
  group('TBlocBuilder Tests', () {
    testWidgets('The bloc should be the given bloc.', (tester) async {
      final matcher = MockBloc('matcher');
      late MockBloc result;

      await tester.pumpWidget(
        TBlocBuilder(
          bloc: matcher,
          builder: (context, bloc, state) {
            result = bloc;
            return Container();
          },
        ),
      );

      expect(result, matcher);
    });

    testWidgets('The bloc should be the provided bloc from context.',
        (tester) async {
      final matcher = MockBloc('matcher');
      late MockBloc result;

      await tester.pumpWidget(
        BlocProvider.value(
          value: matcher,
          child: TBlocBuilder<MockBloc, MockBlocState>(
            builder: (context, bloc, state) {
              result = bloc;
              return Container();
            },
          ),
        ),
      );

      expect(result, matcher);
    });
  });
}
