// import 'package:dartz/dartz.dart';
// import 'api_failure.dart';

// abstract class GetResponseOrErrorFromDataSource {
//   Future<Either<ApiFailure, T>> getResponse<T>({
//     required Future<T> Function() request,
//   });
// }

// @LazySingleton(as: GetResponseOrErrorFromDataSource)
// class GetResponseOrErrorFromDataSourceImpl
//     implements GetResponseOrErrorFromDataSource {
//   final NetworkInfo networkInfo;

//   GetResponseOrErrorFromDataSourceImpl({
//     required this.networkInfo,
//   });

//   @override
//   Future<Either<ApiFailure, T>> getResponse<T>({
//     required Future<T> Function() request,
//   }) async {
//     final isOnline = await networkInfo.isConnected;

//     if (!isOnline) {
//       return Left(ApiFailure.noInternetConnection());
//     }

//     try {
//       return Right(await request());
//     } catch (ex) {
//       if (ex is ServerException) {
//         return Left(ApiFailure.serverError(message: ex.message));
//       }
//       if (ex is FatalException) {
//         return Left(ApiFailure.fatalError(ex.message));
//       }
//       return Left(ApiFailure.fatalError("Something went wrong."));
//     }
//   }
// }
