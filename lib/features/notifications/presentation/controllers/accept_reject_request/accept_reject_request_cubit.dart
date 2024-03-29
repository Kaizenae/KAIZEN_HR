import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../notifications/domain/usecases/accept_reject_request_usecase.dart';
import '../../../domain/entities/accept_reject_request_entity.dart';
import 'accept_reject_request_state.dart';

class AcceptRejectRequestCubit extends Cubit<AcceptRejectRequestState> {
  final AcceptRejectRequestUsecase acceptRejectRequestUsecase;

  AcceptRejectRequestCubit({required this.acceptRejectRequestUsecase})
      : super(AcceptRejectRequestInitial());

  static AcceptRejectRequestCubit get(context) => BlocProvider.of(context);

  int id = 0;
  int isAccept = 0;
  String states = '';

  Future<void> acceptRejectFun() async {
    emit(AcceptRejectRequestLoading());
    Either<Failure, AcceptRejectRequestEntity> response =
        await acceptRejectRequestUsecase(AcceptRejectRequestParams(
      is_accept: isAccept,
      state: states,
      id: id,
    ));

    emit(response
        .fold((failure) => AcceptRejectRequestError(message: failure.message),
            (acceptRejectRequestEntity) {
      return AcceptRejectRequestSuccess(
          acceptRejectRequestEntity: acceptRejectRequestEntity);
    }));
  }

  String typeFun(String value) {
    if (value == 'check_in') {
      return 'Punch in';
    } else if (value == 'check_out') {
      return 'Punch out';
    } else if (value == 'holiday') {
      return 'Holiday';
    } else if (value == 'leave_of_request') {
      return 'Leave Request';
    }
    return '';
  }

  String stateFun(String value) {
    if (value == 'in_progress') {
      return 'In Progress';
    } else if (value == 'reject') {
      return 'Rejected';
    } else if (value == 'done') {
      return 'Accepted';
    }
    return '';
  }

  String stateLoansFun(String value) {
    if (value == 'waiting_approval_1') {
      return 'Submitted';
    } else if (value == 'approve') {
      return 'Approved';
    } else if (value == 'draft') {
      return 'Draft';
    } else if (value == 'cancel') {
      return 'Canceled';
    } else if (value == 'refuse') {
      return 'Refused';
    }
    return '';
  }
}
