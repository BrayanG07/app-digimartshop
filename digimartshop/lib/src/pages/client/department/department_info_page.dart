import 'package:digimartbox/src/constants/constants.dart';
import 'package:digimartbox/src/pages/client/department/department_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepartmentInfoPage extends StatelessWidget {
  DepartmentInfoPage({Key? key}) : super(key: key);
  final DepartmentInfoController departmentController = Get.put(DepartmentInfoController());

  @override
  Widget build(BuildContext context) {
    return  Obx(() =>
        Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'Departamentos',
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
          body:  Container(
            color: Constants.colorGreyBackground,
            child: ListView.builder(
                itemCount: departmentController.departments.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration:  BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 1), // Desplazamiento en horizontal y vertical
                        ),
                      ],
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      onTap: () async => await departmentController.getDepartmentSelected(departmentController.departments[index], context),
                      title: Text(departmentController.departments[index].name),
                      leading: CircleAvatar(
                        backgroundColor: Constants.colorPrimary,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  );
                }
            ),
          ),
        )
    );
  }
}
