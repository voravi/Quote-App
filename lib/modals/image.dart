class myImages {
   String image;

  myImages({required this.image});

  factory myImages.fromMap({required Map data}) {
    return myImages(
      image: data["urls"]["full"],
    );
  }

  factory myImages.fromDB({required Map data}) {
    return myImages(
      image: data["src"],
    );
  }
}
