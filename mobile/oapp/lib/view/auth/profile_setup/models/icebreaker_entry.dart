import 'package:flutter/widgets.dart';

/// One filled icebreaker on "Your icebreakers" (p042, p048, p049, p050, p053).
///
/// Every entry renders inside the same card chrome: a grey kind eyebrow
/// ("PROMPT" / "SNAP" / "GAME"), a green title, an optional body line and a
/// pencil affordance in the top right. What changes is the block underneath,
/// which is why the eight game formats are separate subclasses rather than one
/// bag of optional fields.
sealed class IcebreakerEntry {
  const IcebreakerEntry({required this.title, this.promptId});

  /// The green all-caps line, e.g. "TWO TRUTHS & A LIE".
  final String title;

  /// The `IceBreaker` document this answers. `user/addProfile` stores answers
  /// as a map of prompt id to answer and silently drops anything without an
  /// id, so an entry built from a prompt the API served must carry it.
  final String? promptId;

  String get kindLabel;
}

class PromptIcebreaker extends IcebreakerEntry {
  const PromptIcebreaker({
    required super.title,
    required this.answer,
    super.promptId,
  });

  final String answer;

  @override
  String get kindLabel => 'PROMPT';
}

class SnapIcebreaker extends IcebreakerEntry {
  const SnapIcebreaker({
    required super.title,
    required this.caption,
    this.image,
    super.promptId,
  });

  final String caption;
  final ImageProvider? image;

  @override
  String get kindLabel => 'SNAP';
}

sealed class GameIcebreaker extends IcebreakerEntry {
  const GameIcebreaker({required super.title, super.promptId});

  @override
  String get kindLabel => 'GAME';
}

class MultipleChoiceIcebreaker extends GameIcebreaker {
  const MultipleChoiceIcebreaker({
    super.title = 'MULTIPLE CHOICE',
    required this.statement,
    required this.options,
  });

  final String statement;
  final List<String> options;
}

class TwoTruthsIcebreaker extends GameIcebreaker {
  const TwoTruthsIcebreaker({
    super.title = 'TWO TRUTHS & A LIE',
    required this.statements,
  });

  final List<String> statements;
}

class RankOrderIcebreaker extends GameIcebreaker {
  const RankOrderIcebreaker({
    super.title = 'RANK ORDER',
    required this.caption,
    required this.statements,
  });

  final String caption;
  final List<String> statements;
}

class WouldYouRatherIcebreaker extends GameIcebreaker {
  const WouldYouRatherIcebreaker({
    super.title = 'WOULD YOU RATHER',
    required this.optionA,
    required this.optionB,
  });

  final String optionA;
  final String optionB;
}

class RateThisIcebreaker extends GameIcebreaker {
  const RateThisIcebreaker({
    super.title = 'RATE THIS',
    required this.caption,
    this.image,
    this.value = 5,
    this.steps = 10,
    this.lowLabel = 'Mid',
    this.highLabel = 'Elite',
  });

  final String caption;
  final ImageProvider? image;

  /// Slider position, 0..[steps].
  final int value;
  final int steps;
  final String lowLabel;
  final String highLabel;
}

class ThisOrThatIcebreaker extends GameIcebreaker {
  const ThisOrThatIcebreaker({
    super.title = 'THIS OR THAT',
    required this.pairs,
  });

  /// Left / right option per row.
  final List<(String, String)> pairs;
}

class GreenRedFlagIcebreaker extends GameIcebreaker {
  const GreenRedFlagIcebreaker({
    super.title = 'GREEN OR RED FLAG',
    required this.statement,
    this.greenLabel = 'Green flag',
    this.redLabel = 'Red flag',
  });

  final String statement;
  final String greenLabel;
  final String redLabel;
}

class FinishSentenceIcebreaker extends GameIcebreaker {
  const FinishSentenceIcebreaker({
    super.title = 'FINISH THE SENTANCE',
    required this.stem,
  });

  /// The half sentence before the blank, e.g. "I cant start my day without".
  final String stem;
}
