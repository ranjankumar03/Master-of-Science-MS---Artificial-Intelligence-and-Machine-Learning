# Python for Data Analysis
# By: Atefeh Khazaei
# atefeh.khazaei@port.ac.uk
# Week 2 – Practicals


# function for deciding if input year is leap year
def isLeapYear(year):
	if year % 400 == 0:
		return True
	if year % 100 == 0:
		return False
	if year % 4 == 0:
		return True
	return False

# function for deciding how many days in input month
def daysInMonth(year, month):
	if month == 1 or month == 3 or month == 5 or month == 7 or month == 8 or month == 10 or month == 12:
		return 31
	else:
		if month == 2:
			if isLeapYear(year):
				return 29
			else:
				return 28
		else:
			return 30

# function for validating days in month and months in year
def nextDay(year, month, day):
	if day < daysInMonth(year, month):
		return year, month, day + 1
	else:
		if month < 12:
			return year, month + 1, 1
		else:
			return year + 1, 1, 1
		
	return year,month,day

# function for validating input day, month, and year
def dateIsBefore(year1, month1, day1, year2, month2, day2):
	if year1 < year2:
		return True
	if year1 == year2:
		if month1 < month2:
			return True
		if month1 == month2:
			return day1 < day2
		else:
			return False
	else:
		return False

# function for counting days between input dates
def daysBetweenDates(year1, month1, day1, year2, month2, day2):
	if dateIsBefore(year1, month1, day1, year2, month2, day2) == False:
		return "AssertionError"
	else:
		days = 0
		while dateIsBefore(year1, month1, day1, year2, month2, day2):
			year1, month1, day1 = nextDay(year1, month1, day1)
			days += 1
		return days

# a few tests
print daysBetweenDates(2012,1,1,2012,2,28)
print daysBetweenDates(2012,1,1,2012,3,1)
print daysBetweenDates(2011,6,30,2012,6,30)

# test for error
print daysBetweenDates(2013,1,1,1999,12,31)