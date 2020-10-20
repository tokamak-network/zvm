import sys
import math

if len(sys.argv) != 2:
  print ("Enter infix expression")
  exit(1)

expression = sys.argv[1]

operation_dict = {"+": 0, "-": 1, "*": 2, "/": 3}

json_output = "{\"in\": ["

operation = 0
length = len(expression)

for i in range(int(length / 2)):
    json_output += expression[2 * i] + ", "
    operation += operation_dict[expression[2 * i + 1]] * int(math.pow(len(operation_dict), i))

json_output += expression[len(expression) - 1] + ", " + str(operation) + "]}"

f = open("./src/input.json", 'w')
f.write(json_output)
f.close()