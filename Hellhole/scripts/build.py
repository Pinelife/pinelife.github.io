import os

import yaml


SOURCE = '.\\source'
TARGET = '.\\rooms'


def main():
	# Read the layout files
	layout_path = os.path.join(SOURCE, '_layout.html')
	with open(layout_path, 'r') as f:
		layout_template = f.read()


	# Delete old built files
	print 'Cleaning up old files'
	for old_file_name in os.listdir(TARGET):
		old_file_path = os.path.join(TARGET, old_file_name)
		os.remove(old_file_path)

	# Read room configuration
	room_config_path = '.\\rooms.yaml'
	with open(room_config_path, 'r') as f:
		room_config = yaml.load(f)

	# Build new files
	print 'Building rooms from {}...\n'.format(room_config_path)
	room_names = room_config.keys()
	for room_name in room_names:
		room = room_config[room_name]
		file_name = room_name + '.html'

		print '\t{}'.format(file_name)
		source_file_path = os.path.join(SOURCE, file_name)
		target_file_path = os.path.join(TARGET, file_name)

		# Read source file
		with open(source_file_path, 'r') as f:
			source_file_html = f.read()

		room_prompt = build_prompt(room)

		# Do templating
		html = layout_template.format(
			history='',
			story=source_file_html,
			prompt=room_prompt
		)

		# Write output file
		with open(target_file_path, 'w') as f:
			f.write(html)

	print "Done!\n"


def build_prompt(room):
	if room:
		left_anchor = '<a href="./{room}.html">{text}</a>'.format(**room['left'])
		right_anchor = '<a href="./{room}.html">{text}</a>'.format(**room['right'])
		prompt = room['prompt'].format(left=left_anchor,right=right_anchor)
	else:
		prompt = ''
	return prompt


if __name__ == '__main__':
	main()