class GetPostsRequest {
  final String? userId;
  final String? fromDate;
  final String? toDate;
  final bool? todaysStory;
  final int? limit;
  final int? offset;

  GetPostsRequest({
    this.userId,
    this.fromDate,
    this.toDate,
    this.todaysStory,
    this.limit,
    this.offset,
  });

  Map<String, dynamic> toQuery() {
    return {
      if (userId != null) 'userId': userId,
      if (fromDate != null) 'fromDate': fromDate,
      if (toDate != null) 'toDate': toDate,
      if (todaysStory != null) 'todaysStory': todaysStory.toString(),
      if (limit != null) 'limit': limit.toString(),
      if (offset != null) 'offset': offset.toString(),
    };
  }
}
