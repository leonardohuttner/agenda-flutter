library wc_form_validators;

import 'package:flutter/widgets.dart' show FormFieldValidator;

/// Provides a set of built-in validators that can be used by form fields.
///
///
/// A validator is a function that processes a `FormField`
/// and returns an error [String] or null. A null [String] means that validation has passed.
class Validators {
  /// Validator that requires the field have a non-empty value.
  static FormFieldValidator<String> required(String errorMessage) {
    return (value) {
      if (value == null) {
        value = '';
      }
      if (value.isEmpty)
        return errorMessage;
      else
        return null;
    };
  }

  /// Validator that requires the field's value to be greater than or equal to the provided number.
  static FormFieldValidator<String> min(double min, String errorMessage) {
    return (value) {
      if (value == null) {
        value = '';
      }
      if (value.trim().isEmpty)
        return null;
      else {
        final dValue = _toDouble(value);
        if (dValue < min)
          return errorMessage;
        else
          return null;
      }
    };
  }

  /// Validator that requires the field's value to be less than or equal to the provided number.
  /// Validate against a maximum of 5
  static FormFieldValidator<String> max(double max, String errorMessage) {
    return (value) {
      if (value == null) {
        value = '';
      }
      if (value.trim().isEmpty)
        return null;
      else {
        final dValue = _toDouble(value);
        if (dValue > max)
          return errorMessage;
        else
          return null;
      }
    };
  }

  /// Validator that requires the field's value pass an email validation test.
  ///
  /// This validator uses Regex of HTML5 email validator.
  ///
  /// ```dart
  /// RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  /// ```
  static FormFieldValidator<String> email(String errorMessage) {
    return (value) {
      if (value == null) {
        value = '';
      }
      if (value.isEmpty)
        return null;
      else {
        final emailRegex = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
        if (emailRegex.hasMatch(value))
          return null;
        else
          return errorMessage;
      }
    };
  }

  /// Validator that requires the length of the field's value to be greater than or equal
  /// to the provided minimum length.
  ///
  ///
  /// ### Validate that the field has a minimum of 5 characters
  static FormFieldValidator<String> minLength(
      int minLength, String errorMessage) {
    return (value) {
      if (value == null) {
        value = '';
      }
      if (value.isEmpty) return null;

      if (value.length < minLength)
        return errorMessage;
      else
        return null;
    };
  }

  /// Validator that requires the length of the field's value to be less than or equal
  /// to the provided maximum length.
  ///
  ///
  /// ### Validate that the field has maximum of 5 characters
  static FormFieldValidator<String> maxLength(
      int maxLength, String errorMessage) {
    return (value) {
      if (value == null) {
        value = '';
      }
      if (value.isEmpty) return null;

      if (value.length > maxLength)
        return errorMessage;
      else
        return null;
    };
  }

  /// Validator that requires the field's value to match a regex pattern.
  /// Note that if a Regexp is provided, the Regexp is used as is to test the values.
  /// Validate that the field only contains alphabets

  static FormFieldValidator<String> patternString(
      String pattern, String errorMessage) {
    return patternRegExp(RegExp(pattern), errorMessage);
  }

  /// Validator that requires the field's value to match a regex pattern.
  /// Note that if a Regexp is provided, the Regexp is used as is to test the values.
  static FormFieldValidator<String> patternRegExp(
      RegExp pattern, String errorMessage) {
    return (value) {
      if (value == null) {
        value = '';
      }
      if (value.isEmpty) return null;

      if (pattern.hasMatch(value))
        return null;
      else
        return errorMessage;
    };
  }

  /// Compose multiple validators into a single validator.
  static FormFieldValidator<String> compose(
      List<FormFieldValidator<String>> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  // -------------------- private functions ---------------------- //

  static double _toDouble(String value) {
    value = value.replaceAll(' ', '').replaceAll(',', '');
    return double.parse(value);
  }
}
