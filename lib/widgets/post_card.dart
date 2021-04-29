import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:technical_task/models/post.dart';
import 'package:technical_task/utils/pref_manager.dart';
import 'package:technical_task/widgets/custom_input_field.dart';
import 'package:technical_task/widgets/custom_textview.dart';
import 'package:web_socket_channel/io.dart';

class PostCard extends StatefulWidget {
  final Post post;

  PostCard({@required this.post});

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  IOWebSocketChannel _webSocketChannel;

  @override
  void initState() {
    super.initState();
    _webSocketChannel = IOWebSocketChannel.connect("ws://13.232.72.245:8895");
    _webSocketChannel.stream.listen((event) { 
      print("EVENT: $event");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.post.profileImage),
                          radius: 30,
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RichText(
                            maxLines: null,
                            text: TextSpan(
                              style: TextStyle(
                                color: Colors.black
                              ),
                              children: [
                                TextSpan(
                                  text: widget.post.profileName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                  )
                                ),
                                TextSpan(
                                  text: " is at ${widget.post.location ?? "New York"}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.grey.shade500,
                                  )
                                ),
                              ]
                            )
                          ),

                          Container(
                            child: CustomTextView(
                              text: "Just now",
                              textColor: Colors.grey.shade500,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                Icon(Icons.more_horiz)
              ],
            ),

            Container(
              margin: const EdgeInsets.only(top: 15),
              child: _buildMediaWidget(),
            ),

            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async{
                          await _likeOrDislikePost(isLike: true);
                        },
                        icon: Icon(CupertinoIcons.hand_thumbsup),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black
                          ),
                          children: [
                            TextSpan(
                              text: "${widget.post.reactsCount ?? 0}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            TextSpan(
                              text: " Others",
                              style: TextStyle(
                              )
                            )
                          ]
                        )
                      )
                    ],
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextView(
                        text: "${widget.post.commentsCount ?? 0}",
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5, right: 10),
                        child: Icon(
                          CupertinoIcons.bubble_left
                        ),
                      ),
                      CustomTextView(
                        text: "${widget.post.shared ?? 0}",
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: Icon(
                          CupertinoIcons.arrow_turn_up_right
                        ),
                      )
                    ],
                  ),

          
                ],
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                child: CustomTextView(
                  text: "View all ${widget.post.commentsCount} comments"
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade300
              ),
              child: CustomInputField(
                controller: TextEditingController(),
                hint: "Write a comment",
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _likeOrDislikePost({@required bool isLike}) async{
    final body = {
      "authorization" : "12345",
      "user_token" : await PrefManager.getUserToken(),
      "sender" : {
        "id" : await PrefManager.getUserId(),
        "image" : await PrefManager.getUserImageUrl()
      },
      "ref_id" : "327",
      "react" : isLike ? "react" : "",
      "request" : "post",
      "type": "react"
    };
    print("WEB SOCKET BODY: $body");
    _webSocketChannel.sink.add(json.encode(body));
  }

  Widget _buildMediaWidget(){
    if(widget.post.postType ==  "photo"){
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.post.imageUrl)
              )
            ),
          ),
          Positioned(
            bottom: 6,
            left: 6,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.black.withOpacity(0.5)
              ),
              child: IconButton(
                icon: Icon(Icons.person_outline, color: Colors.white), 
                onPressed: (){

                }
              ),
            ),
          ),

          Positioned(
            right: 6, 
            bottom: 6,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.black.withOpacity(0.5)
              ),
              child: IconButton(
                icon: Icon(Icons.location_on_outlined, color: Colors.white), 
                onPressed: (){

                }
              ),
            ),
          )
        ],
      );
    }else if (widget.post.postType == "text"){
      return Container(
        height: 150,
        child: CustomTextView(
          text: "${widget.post.content ?? "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi id mauris neque. Suspendisse eget pharetra turpis. Pellentesque posuere, orci in venenatis finibus, quam velit fringilla nulla, quis feugiat quam ex non leo. Vivamus interdum, turpis vitae luctus semper, lacus erat blandit felis, id aliquet augue felis non nisi"}",
          textColor: Colors.blue.shade600,
        ),
      );
    }else if(widget.post.postType == "video"){
      if(widget.post.videoUrl.isEmpty){
        return Container(
          child: Center(
            child: CustomTextView(
              text: "NO VIDEO AVAILABLE",
              fontSize: 15.0,
            )
          ),
        );
      }else{
        return Container(
          child: Center(
            child: CustomTextView(
              text: "VIDEO HERE",
              fontSize: 15.0,
            )
          ),
        );
      }
      
    }else{
      return Container();
    }
  }
}