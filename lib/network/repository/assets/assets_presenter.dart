import 'package:kona_ice_pos/network/exception.dart';
import 'package:kona_ice_pos/network/repository/assets/assets_repository.dart';
import 'package:kona_ice_pos/network/response_contractor.dart';

class AssetsPresenter{
 late final AssetsResponseContractor _view;
 late AssetsRepository repository;

 AssetsPresenter(this._view){
   repository = AssetsRepository();
 }

 void getAssets(){
  repository.getAssets().then((value){
   _view.showAssetsSuccess(value);
  }).onError((error, stackTrace){
   _view.showAssetsError(FetchException(error.toString()).fetchErrorModel());
  });
 }
}