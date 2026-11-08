class HardCodedData {
  static List<String> heightOptions = [
    'Shorter than me',
    'About my height',
    'Taller than me',
    '5 ft 0 in +',
    '5 ft 2 in +',
    '5 ft 4 in +',
    '5 ft 6 in +',
    '5 ft 8 in +',
    '5 ft 10 in +',
    '6 ft 0 in +',
    '6 ft 2 in +',
    '6 ft 4 in +',
    '6 ft 6 in +',
    '6 ft 8 in +',
    '7 ft 0 in +',
    'No preference',
  ];

  static List<String> politicalOptions = [
    'Conservative',
    'Liberal',
    'Moderate',
    'Libertarian',
    'Progressive',
    'Independent',
    'Centrist',
    'Socialist',
    'Green',
    'Other',
  ];

  static final List<String> educationLevels = [
    'High School',
    'Bachelors',
    'Doctorate',
    'Associates',
    'Masters',
    'Open to all',
  ];

  static final List<String> languages = [
    'English',
    'Spanish',
    'French',
    'Portuguese',
    'Farsi',
    'German',
    'Italian',
    'Arabic',
    'Hindi',
    'Mandarin',
    'Dutch',
    'Hebrew',
    'Japanese',
    'Russian',
    'Tagalog',
    'Urdu',
    'Other',
  ];

  static final List<String> ethnicities = [
    'Asian',
    'Black',
    'Hispanic',
    'Middle Eastern',
    'Native American',
    'Pacific Islander',
    'South Asian',
    'White',
    'Mixed Race',
    'Other',
  ];
  static final List<String> religiousViews = [
    'Agnostic',
    'Bahai',
    'Buddhist',
    'Catholic',
    'Christian',
    'Hindu',
    'Jewish',
    'Muslim',
    'Shinto',
    'Sikh',
    'Spiritual',
    'Other',
    'Prefer not to say',
  ];
  static final List<String> genderOptions = ['Man', 'Woman', 'Non binary'];
  static final List<String> datingGenderOptions = [
    'Men',
    'Women',
    'Non binary',
    "Everyone",
  ];
  static final List<String> quickJobOptions = [
    'Student',
    'Part-Time',
    'Entrepreneur',
    'White Collar',
    'Blue Collar',
    'Prefer not to say',
  ];

  static final List<String> habitOptions = [
    'Socially',
    'Never',
    'Often',
    "None",
  ];

  static final List<String> politicsOptions = [
    'Conservative',
    'Liberal',
    'Moderate',
    'Who cares',
    'Green',
    'Prefer not to say',
  ];

  static final List<String> platforms = [
    'Instagram',
    'Linkedin',
    'Facebook',
    'TikTok',
    'Pine',
    'X',
  ];

  static List<String> monthNames() {
    return [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
  }

  static String getZodiacSign(int month, int day) {
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'Aries';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'Taurus';
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return 'Gemini';
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return 'Cancer';
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Leo';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'Virgo';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return 'Libra';
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return 'Scorpio';
    }
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return 'Sagittarius';
    }
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return 'Capricorn';
    }
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return 'Aquarius';
    }
    if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) return 'Pisces';
    return 'Unknown';
  }
}

class HardCodedDataFormatter {
  static String formatHeight(String? height) {
    if (height == null || height.isEmpty) return "";

    // Handle non-numeric options
    if (height.contains("Shorter") ||
        height.contains("Taller") ||
        height.contains("About") ||
        height.contains("No preference")) {
      return height;
    }

    // Extract feet and inches using RegExp
    final regex = RegExp(r'(\d+)\s*ft\s*(\d+)?\s*in?');
    final match = regex.firstMatch(height);

    if (match != null) {
      final feet = match.group(1);
      final inches = match.group(2) ?? "0";

      return "$feet'$inches''";
    }

    return height;
  }
}
