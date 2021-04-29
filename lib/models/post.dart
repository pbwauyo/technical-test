class Post {
  int id;
  String postType;
  String title;
  String content;
  String profileName;
  String profileImage;
  String location;
  int commentsCount;
  String reactIcon;
  int reactsCount;
  int shared;
  String imageUrl;
  String videoUrl;
  String postDateUtc;

  Post({this.id, this.postType, this.title, this.content, this.profileName, this.profileImage, 
    this.location, this.commentsCount, this.reactIcon, this.reactsCount, this.shared, this.imageUrl, this.videoUrl, this.postDateUtc});


  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
      id: json["ID"],
      postType: json["post_type"],
      title: json["title"],
      content: json["content"],
      profileName: json["details"]["name"],
      profileImage: json["details"]["image"],
      location: null,
      commentsCount: json["comments"],
      reactIcon: json["reacts"].length > 0 ? json["reacts"][0]["rc"] : "",
      reactsCount: json["reacts"].length > 0 ? json["reacts"][0]["cn"] : 0,
      shared: null,
      imageUrl: json["image"],
      videoUrl: json["video"],
      postDateUtc: json["post_date_utc"]
    );
  }

  @override
  String toString() {
    return "{postType: $postType, title: $title, content: $content, profileName: $profileName, profileImage: $profileImage, location: $location, commentsCount: $commentsCount, reactIcon: $reactIcon, location: $location, commentsCount: $commentsCount, reactIcon: $reactIcon, reactsCount: $reactsCount, shared: $shared, imageUrl: $imageUrl, videoUrl: $videoUrl, postDateUtc: $postDateUtc";
  }
}