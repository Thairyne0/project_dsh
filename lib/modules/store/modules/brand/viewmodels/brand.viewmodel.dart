import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_dsh/ui/widgets/cl_media_viewer.widget.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../utils/api_manager.util.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/models/upload_file.model.dart';
import '../constants/brand_api_calls.costant.dart';
import '../models/brand.model.dart';

class BrandViewModel extends CLBaseViewModel {
  late TextEditingController nameTEC = TextEditingController();
  late TextEditingController descriptionTEC = TextEditingController();
  CLMedia? imageFile;
  late Brand brand;
  PagedDataTableController<String, String, Brand> brandTableController = PagedDataTableController<String, String, Brand>();

  BrandViewModel(BuildContext context, VMType viewModelType, dynamic extraParams)
      : super(viewContext: context, viewModelType: viewModelType, extraParams: extraParams);

  @override
  Future initialize({List<PageAction>? pageActions}) async {
    setBusy(true);
    await super.initialize(pageActions: pageActions);
    switch (viewModelType) {
      case VMType.list:
        break;
      case VMType.create:
        break;
      case VMType.edit:
        String brandId = extraParams as String;
        brand = await getBrand(brandId);
        nameTEC.text = brand.name;
        descriptionTEC.text = brand.description;
        imageFile = CLMedia(fileUrl: brand.imageUrl);
        break;
      case VMType.detail:
        String brandId = extraParams as String;
        brand = await getBrand(brandId);
        break;
      default:
        break;
    }
    setBusy(false);
  }

  Future<(List<Brand>, Pagination?)> getAllBrand({int? page, int? perPage, Map<String, dynamic>? searchBy, Map<String, dynamic>? orderBy}) async {
    late List<Brand> brandArray = [];
    ApiCallResponse apiCallResponse = await BrandCalls.getAllBrands(viewContext, page: page, perPage: perPage, searchParams: searchBy, orderByParams: orderBy);
    if (apiCallResponse.succeeded) {
      final brandsJsonObject = (apiCallResponse.jsonBody as List);
      brandsJsonObject.asMap().forEach(
        (index, jsonObject) {
          brandArray.add(Brand.fromJson(jsonObject: jsonObject));
        },
      );
    }
    return (brandArray, apiCallResponse.pagination);
  }

  Future<Brand> getBrand(brandId) async {
    late Brand downloadedBrand;
    ApiCallResponse apiCallResponse = await BrandCalls.getBrand(viewContext, brandId);
    if (apiCallResponse.succeeded) {
      downloadedBrand = Brand.fromJson(jsonObject: apiCallResponse.jsonBody);
    }
    return downloadedBrand;
  }

  Future deleteBrand(brandId) async {
    setBusy(true);
    ApiCallResponse apiCallResponse = await BrandCalls.deleteBrand(viewContext, brandId);
    setBusy(false);
  }

  Future createBrand() async {
    setBusy(true);
    Map<String, dynamic> params = {
      "name": nameTEC.text,
      "description": descriptionTEC.text,
    };
    if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }
    ApiCallResponse apiCallResponse = await BrandCalls.createBrand(viewContext, params);
    setBusy(false);
  }

  Future updateBrand(String brandId) async {
    setBusy(true);
    Map<String, dynamic> params = {
      "name": nameTEC.text,
      "description": descriptionTEC.text,
    };
    if (imageFile != null) {
      params.addAll({"image": FFUploadedFile(clMedia: imageFile!)});
    }
    ApiCallResponse apiCallResponse = await BrandCalls.updateBrand(viewContext, params, brandId);
    setBusy(false);
  }
}
