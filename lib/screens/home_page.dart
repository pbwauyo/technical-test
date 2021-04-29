import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:technical_task/models/post.dart';
import 'package:technical_task/utils/pref_manager.dart';
import 'package:technical_task/widgets/post_card.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _pageSize = 20;
  final PagingController<int, Post> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey){
      _fetchPosts(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: PagedListView(
        pagingController: _pagingController, 
        builderDelegate: PagedChildBuilderDelegate<Post>(
          itemBuilder: (context, post, index){
            return PostCard(post: post);
          }
        )
      ),
    );
  }

  Future<void> _fetchPosts(int pageKey) async{
    final userToken = await PrefManager.getUserToken();
    final url = "http://13.232.72.245:3200/postslist?user_token=$userToken&page=$pageKey&user_only=4";

    try{
      final postsResponse = await http.get(Uri.parse(url));
      final parsedResponse = Map<String, dynamic>.from(json.decode(postsResponse.body));
      
      final postsList = parsedResponse["data"].map((postJson) => Post.fromJson(postJson)).toList().cast<Post>();
      postsList.forEach((post) => print("POST TYPE: ${post.postType} and POST CONTENT: ${post.content}"));
      final isLastPage = parsedResponse["data"].length == 0;
      if(isLastPage){
        _pagingController.appendLastPage([]);
      }else{
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(postsList, nextPageKey);
      }
    }catch(error){
      print("PAGING ERROR: $error");
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}