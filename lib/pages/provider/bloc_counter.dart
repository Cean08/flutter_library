
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 状态类继承Equatable
abstract class CounterState extends Equatable {
  final int count;
  const CounterState(this.count);

  @override
  // TODO: implement props
  List<Object?> get props => [count];
}

class CounterInitial extends CounterState {
  // 初始状态count为0
  const CounterInitial() : super(0);
}

// 增加后的状态
class CounterIncremented extends CounterState {
  const CounterIncremented(super.count);
}

// 减少后的状态
class CounterDecremented extends CounterState {
  const CounterDecremented(super.count);
}


class CounterCubit extends Cubit<CounterState> {
  CounterCubit(): super(const CounterInitial());
  void increment() {
    // 使用emit方法发布新状态
    emit(CounterIncremented(state.count + 1));
  }

  void decrement() {
    if (state.count > 0) {
      emit(CounterDecremented(state.count - 1));
    }
  }

  void reset() {
    emit(const CounterInitial());
  }
}
/*
// counter_cubit.dart
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState.initial());

  void increment() {
    emit(state.copyWith(count: state.count + 1));
    // 或者直接：emit(CounterState(state.count + 1));
  }

  void decrement() {
    if (state.count > 0) {
      emit(state.copyWith(count: state.count - 1));
    }
  }

  void reset() {
    emit(const CounterState.initial());
  }
}
 */