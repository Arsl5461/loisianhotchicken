class IceBreakerModel {
  String? id;
  String? prompt;
  String? answer;

  IceBreakerModel({this.id, this.prompt, this.answer});

  factory IceBreakerModel.fromJson(Map<String, dynamic> json) {
    return IceBreakerModel(
      id: json['_id'],
      prompt: json['prompt'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'prompt': prompt, 'answer': answer};
  }

  IceBreakerModel copyWith({String? id, String? answer}) {
    return IceBreakerModel(
      id: id ?? this.id,
      prompt: prompt, // prompt remains unchanged
      answer: answer ?? this.answer,
    );
  }
}
