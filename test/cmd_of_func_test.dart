import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:dartea/dartea.dart';

import 'testable_program.dart';
import 'counter_app.dart';

void main() {
  group('cmd of function', () {
    testWidgets('0 args success', (WidgetTester tester) async {
      var initArg = 0;
      var sideEffect = "side effect!";
      var effect = Cmd.ofFunc<String, Message>(() => sideEffect,
          onSuccess: (x) => OnSuccessEffectWithResult(x));
      var program =
          TestProgram((start) => init(start, effect: effect), update, view);
      program.runWith(initArg);

      await tester.pumpWidget(program.frames.removeLast());
      await tester.tap(find.byKey(effectBtnKey));
      await tester.pumpWidget(program.frames.removeLast());

      expect(
          program.updates,
          emitsInOrder([
            predicate((Message m) => m is DoSideEffect),
            predicate((Message m) =>
                m is OnSuccessEffectWithResult && m.result == sideEffect)
          ]));
    });

    testWidgets('1 arg success', (WidgetTester tester) async {
      var initArg = 0;
      var sideEffect = "side effect!";
      var effect = Cmd.ofFunc1<String, Message, String>(
          (arg) => arg, sideEffect,
          onSuccess: (x) => OnSuccessEffectWithResult(x));
      var program =
          TestProgram((start) => init(start, effect: effect), update, view);
      program.runWith(initArg);

      await tester.pumpWidget(program.frames.removeLast());
      await tester.tap(find.byKey(effectBtnKey));
      await tester.pumpWidget(program.frames.removeLast());

      expect(
          program.updates,
          emitsInOrder([
            predicate((Message m) => m is DoSideEffect),
            predicate((Message m) =>
                m is OnSuccessEffectWithResult && m.result == sideEffect)
          ]));
    });

    testWidgets('2 args success', (WidgetTester tester) async {
      var initArg = 0;
      var arg1 = "side ";
      var arg2 = "effect!";
      var effect = Cmd.ofFunc2<String, Message, String, String>(
          (arg1, arg2) => arg1 + arg2, arg1, arg2,
          onSuccess: (x) => OnSuccessEffectWithResult(x));
      var program =
          TestProgram((start) => init(start, effect: effect), update, view);
      program.runWith(initArg);

      await tester.pumpWidget(program.frames.removeLast());
      await tester.tap(find.byKey(effectBtnKey));
      await tester.pumpWidget(program.frames.removeLast());

      expect(
          program.updates,
          emitsInOrder([
            predicate((Message m) => m is DoSideEffect),
            predicate((Message m) =>
                m is OnSuccessEffectWithResult && m.result == arg1 + arg2)
          ]));
    });

    testWidgets('3 args success', (WidgetTester tester) async {
      var initArg = 0;
      var arg1 = "side ";
      var arg2 = "effect";
      var arg3 = "!";
      var effect = Cmd.ofFunc3<String, Message, String, String, String>(
          (arg1, arg2, arg3) => arg1 + arg2 + arg3, arg1, arg2, arg3,
          onSuccess: (x) => OnSuccessEffectWithResult(x));
      var program =
          TestProgram((start) => init(start, effect: effect), update, view);
      program.runWith(initArg);

      await tester.pumpWidget(program.frames.removeLast());
      await tester.tap(find.byKey(effectBtnKey));
      await tester.pumpWidget(program.frames.removeLast());

      expect(
          program.updates,
          emitsInOrder([
            predicate((Message m) => m is DoSideEffect),
            predicate((Message m) =>
                m is OnSuccessEffectWithResult &&
                m.result == arg1 + arg2 + arg3)
          ]));
    });

    testWidgets('error', (WidgetTester tester) async {
      var initArg = 0;
      var sideEffect = "side effect!";
      var error = new Exception(sideEffect);
      var effect = Cmd.ofFunc<String, Message>(() => throw error,
          onSuccess: (x) => OnSuccessEffectWithResult(x),
          onError: (Exception e) => ErrorMessage(e.toString()));
      var program =
          TestProgram((start) => init(start, effect: effect), update, view);
      program.runWith(initArg);

      await tester.pumpWidget(program.frames.removeLast());
      await tester.tap(find.byKey(effectBtnKey));
      await tester.pumpWidget(program.frames.removeLast());

      expect(
          program.updates,
          emitsInOrder([
            predicate((Message m) => m is DoSideEffect),
            predicate((Message m) {
              if (m is ErrorMessage) {
                return m.message == error.toString();
              }
              return false;
            })
          ]));
    });
  });
}