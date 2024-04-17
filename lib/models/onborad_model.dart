class OnBoardContent {
  String image;
  String title;
  String description;
  OnBoardContent(
      {required this.image, required this.title, required this.description});
}

List<OnBoardContent> onBoardContentsList = [
  OnBoardContent(image: 'images/screen1.png', title: "Select from our \n    Best Menu", description: "Pick your food from our menu \n         More than 35 times"),
  OnBoardContent(image: 'images/screen2.png', title: "Easy and Online Payment", description: "You can pay cash on delivery and \n     Card payment is also available"),
  OnBoardContent(image: 'images/screen3.png', title: "Quick Delivery at your DoorStep", description: "Deliver your food at your \n             Doorstep"),

];
