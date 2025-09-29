.PHONY=requirements

requirements:
	 uv export --no-hashes --format requirements.txt -o requirements.txt --no-dev
	 cat - requirements.txt > temp_requirements.txt && mv temp_requirements.txt requirements.txt
