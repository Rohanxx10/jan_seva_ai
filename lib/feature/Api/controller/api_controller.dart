

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:java_seva_ai/feature/Api/api_repository/api_respository.dart';
import 'package:java_seva_ai/modal/scheme_model.dart';


final ApiControllerProvider=Provider((ref){
  final api_repo=ref.watch(ApiRespositoryProvider);
  return ApiController(apiRepository: api_repo);
});

class ApiController{

  final ApiRepository apiRepository;

  ApiController({required this.apiRepository});

  Future<Scheme?> callApiWithUserQuery({required query,required ref,required context}) async {
    return apiRepository.callApiWithUserQuery(query: query, ref: ref,context: context);
  }

}