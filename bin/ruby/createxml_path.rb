#!/usr/bin/ruby
#include Comparable

#MasterTree
class MasterTree < Dir
	
	#initialize
	def	initialize(directoryName)
		super(directoryName)
		@rootDirectory	= directoryName
	end
	
	#createTree
	def	self.createTree(cmdArgs)
		validateArgs(cmdArg)
		ind				= cmdArg.index("-d")
		directoryName	= cmdArg[ind + 1]
		t1				= MasterTree.new(directoryName)
		return			t1
	end
	
	#printTree
	def	printTree
		print			"The root directory is #{@rootDirectory}\n"
		#instance method passes filename of each entry as aprameter to the block
		self.each	{|name|
			puts		"#{name}"
			puts		name.findRegExp()
		}
		
	end
	
	#writeXmlFile
	def	writeXmlFile
		
	end

	#findRegExp
	def	findRegExp(aRegExp)
	
		#test number of arguments
 		if !aRegExp.exist?	then
 			aRegExp		=	"*CEL"
 		end
 		if self.glob(aRegExp)==true then
			return self.glob(aRegExp)
		else
			return ""
	end
	#validateArgs
	def	self.validateArgs(cmdArgs)

		#test number of arguments
 		if cmdArgs.length < 2 then
 			raise ArgumentError, "Too few arguments", caller
 		end
 		
		#test param
		if ! cmdArgs.include?("-d") then
			raise ArgumentError, "You must specify a root directory with the option -d", caller
		else
			ind		= cmdArgs.index("-d")
			if ! File.exist?(cmdArgs[ind + 1]) || ! File.directory?(cmdArgs[ind + 1]) then
				raise "This argument is not a root directory: #{cmdArgs[ind + 1]}"
			end
		end
	end
	
end

mt1 = MasterTree.createTree($*)
mt1.printTree
#mt1.writeXmlFile


#les variables 



