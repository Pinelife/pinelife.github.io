import os
from shutil import copyfile

SOURCE = './src'
IGNORED = [
	'_layout.html',
	'paneltest.html',
	'ChickenQuest.html',
]

# Read the layout file
with open('./src/_layout.html', 'r') as f:
	layout_template = f.read()

print('Building files...')
files = os.listdir(SOURCE)
for file in files:
	if file in IGNORED:
		print '\tIgnorning {}'.format(file)
		continue
	print '\tBuilding {}'.format(file)

	file_path = os.path.join(SOURCE, file)

	# Read source file
	with open(file_path, 'r') as f:
		file_html = f.read()

	# Do templating
	html = layout_template.format(
		previous='',
		content=file_html
	)

	# Write output file
	with open(file, 'w') as f:
		f.write(html)
