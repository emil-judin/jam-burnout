# Resource für eine Liste von Scores bestehend aus einem Array mit Namen, einem Array mit Scores
# und einer Funktion add_score_entry, die den Arrays jeweils ein neues Element hinzufügt
extends Resource
class_name ScoreList

@export var names: Array [String]
@export var scores: Array [int]

# Funktion die einen namen(string) und eine zeit(strig) annimmt und sie zu dem jeweiligen Array hinzufügt
func add_score_entry (name:String, score: int):
	names.append(name)
	scores.append(score)

func get_sorted_by_highscore() -> ScoreList:
	var unsorted_highscore_list = self.duplicate() as ScoreList
	var sorted_highschore_list = ScoreList.new()
	
	var sorted_highscores = scores.duplicate()
	sorted_highscores.sort()
	for i in range(0, sorted_highscores.size()):
		var score = sorted_highscores[i]
		var index = unsorted_highscore_list.scores.find(score)
		var key = unsorted_highscore_list.names[index]
		sorted_highschore_list.names.insert(0, key)
		sorted_highschore_list.scores.insert(0, score)
		unsorted_highscore_list.scores[index] = -1
	
	return sorted_highschore_list
