  // void getinventaryf() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   inventarydispose = database
  //       .child(widget.companyid)
  //       .child("inventary")
  //       .child('/${widget.uuid}')
  //       .onValue
  //       .listen((DatabaseEvent event) async {
  //     getinventary = event.snapshot.value as Map;
  //     to_email = getinventary['partnerbrandemail'];
  //     var tonconversion = getinventary['perpieceweight'] / 1000;
  //     setState(() {
  //       inventrypercentage =
  //           getinventary['weight'] / getinventary['totalweight'] * 100;
  //       getinventary['totalweight'];
  //       getinventary['weight'];
  //       noofpieces = getinventary['weight'] / tonconversion;
  //     });
  //     message =
  //         "Respected manager of  ${getinventary['partnerbrandname']} industry our inventary is going out of stock so we request an order to refill our inventary stock to produce smooth running of supply chin without any distubance. our inventary is reached to as low as ${inventrypercentage.isNaN || inventrypercentage.isInfinite == true ? 0 : inventrypercentage.toInt()} % please refill our stocks ";
  //     // if (inventrypercentage < 25 && backgroundmailcheck == true) {
  //     //   sendinventarymail(
  //     //       to_email, to_name, from_email, from_name, user_subject, message);
  //     //   backgroundmailcheck = false;
  //     // } else {}

  //     if (inventrypercentage < 25) {
  //       prefs.setBool('backgroundmailcheck', false);
  //     }

  //     if (inventrypercentage == 25 &&
  //         prefs.getBool('backgroundmailcheck') == true) {
  //       print(" email send ");
  //       sendinventarymail(
  //           to_email, to_name, from_email, from_name, user_subject, message);
  //       prefs.setBool('backgroundmailcheck', false);
  //     }

  //     if (inventrypercentage > 25) {
  //       prefs.setBool('backgroundmailcheck', true);
  //       print(" enventary is good ");
  //     }
  //   });

  //   print(
  //       "emailstatement ${prefs.getBool('backgroundmailcheck')}================}");
  // }