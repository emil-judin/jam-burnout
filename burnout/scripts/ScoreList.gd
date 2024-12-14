# Resource für eine Liste von Scores bestehend aus einem Array mit Namen, einem Array mit Scores
# und einer Funktion add_score_entry, die den Arrays jeweils ein neues Element hinzufügt
extends Resource
class_name ScoreList


@export var names: Array [String]
@export var times: Array [String]


# Funktion die einen namen(string) und eine zeit(strig) annimmt und sie zu dem jeweiligen Array hinzufügt
func add_score_entry (name:String, time: String):
	names.append(name)
	times.append(time)
