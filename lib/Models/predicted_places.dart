class PredictionPlaces {
  String? placeId;
  String? mainText;
  String? secondaryText;

  PredictionPlaces({
    this.placeId,
    this.mainText,
    this.secondaryText,
  });

  PredictionPlaces.fromJson(Map<String, dynamic> jsonData) {
    placeId = jsonData["place_id"];
    mainText = jsonData["structured_formatting"]["main_text"];
    secondaryText = jsonData["structured_formatting"]["secondary_text"];
  }
}
