
import CreateML
import Foundation

let trainingData = try MLDataTable(contentsOf: Bundle.main.url(forResource: "rs", withExtension: "json")!)

let model = try MLWordTagger(trainingData: trainingData, tokenColumn: "tokens", labelColumn: "labels")
try model.write(toFile: "/Users/bsuthar/Desktop/ner.mlmodel")


var op = try model.prediction(from: "nutrition facts 4 servings per container serving size 1 1/2 cup (208g) amount per serving calories 240 daily value' total fat 4g 5% saturated fat 1.5g 8% trans fat 0g cholesterol 5mg 2% sodium 430mg 19% total carbohydrate 46g 17% dietary fiber 7g 25% total sugars 4g includes 2g added sugars 4% protein 11g vitamin d 2mcg 10% calcium 260mg 20% iron 6mg 35% potassium 240mg 6% the % daily value (dv) tels you how much a nutrient in a serving of food contributes to a daily diet. 2,000 calories a day is used for general nutrition advice.")
print(op)
