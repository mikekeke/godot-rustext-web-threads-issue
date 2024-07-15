godot-website:
	python3 serve.py -n -p 8060 --root ./web-export

canary-website:
	python3 serve.py -n -p 8060 --root ./canary-web-export

signals-website:
	python3 serve.py -n -p 8060 --root ./using-signals-web


