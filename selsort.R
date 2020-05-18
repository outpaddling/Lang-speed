
###########################################################################
# How not to write an R script
# No vector operations, explicit interpreted loops
###########################################################################

# Main program
args <- commandArgs(trailingOnly=TRUE)
if ( (length(args) != 1) )
{
    print("Usage: RScript selsort.R input-file")
    stop()
}
infile <- args[1]

# Read list
nums <- as.integer(scan(file=infile, what=integer()))
list_size <- nums[1]

# Make nums accessible as an array
dim(nums) <- c(length(nums))

last <- length(nums)
print(last)

# Sort list
for (top in 2:last-1)
{
    # Find smallest
    low <- top
    c2 <- top+1
    while (c2 <= last)
    {
	if ( nums[c2] < nums[low] )
	{
	    low <- c2
	}
	c2 <- c2 + 1
    }
    
    temp <- nums[low]
    nums[low] <- nums[top]
    nums[top] <- temp
}

# print list
for (c in 2:length(nums))
{
    print(nums[c])
}
