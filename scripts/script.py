'''This script convert tab-separeted export of workbrenck in .xml file to test in agent-boss as dataset '''
#!/usr/bin/python
import sys, getopt

def main(argv):
	inputfile = ''
	outputfile = ''
	tablename=''
	try:
		opts, args = getopt.getopt(argv,"hi:o:t:",["ifile=","ofile=","ntable="])
	except getopt.GetoptError:
		print 'test.py -i <inputfile> -o <outputfile> -t <tablename>'
		sys.exit(2)
	for opt, arg in opts:
		if opt == '-h':
			print 'test.py -i <inputfile> -o <outputfile> -t <tablename>'
			sys.exit()
		elif opt in ("-i", "--ifile"):
			inputfile = arg
		elif opt in ("-o", "--ofile"):
			outputfile = arg
		elif opt in ("-t", "--ntable"):
			tablename = arg

	lines = [line.rstrip('\n') for line in open(inputfile)]
	names = lines.pop(0).split('\t')

	datasetNameOpen = "<dataset>"
	datasetNameClose = "</dataset>"

	tableNameOpen = "<" + tablename
	tableNameClose = "/>"

	dateColumns = ["givenToAgentTime","timestamp","callDate","created","TIME", "processingAddressEnded", 
			"dialStart", "dialEnd", "conversationStarted", "prospect", "sessionUpdated", "saleClosed"]
	datasetOutput = open(outputfile, 'w')
	datasetOutput.write(datasetNameOpen + '\n')

	for line in lines:
		row = line.split('\t')
		outputRow = tableNameOpen + '\t'
		for col,name in zip(row,names):
			if col != "NULL":
				if name not in dateColumns:
					outputRow += name + ' = "' + col + '"' + '\t'
				else:
					outputRow += name + ' = ' + col + '\t'
			else:
				outputRow += name + ' = "[NULL]"' + '\t'
		outputRow += tableNameClose + '\n'
		datasetOutput.write(outputRow)	
	datasetOutput.write(datasetNameClose + '\n')
	datasetOutput.close()	

if __name__ == "__main__":
	main(sys.argv[1:])
