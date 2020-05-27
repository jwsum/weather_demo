import 'package:flutter/material.dart';
import 'package:progress_hud/progress_hud.dart';

class LoadingDialog extends StatelessWidget {
  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.grey,
      borderRadius: 5.0,
      loading: true,
      text: "Loading.."
    );
  }
}
