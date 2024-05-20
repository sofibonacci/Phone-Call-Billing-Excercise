!classDefinition: #TelephoneBillingTest category: 'TelephoneBilling'!
TestCase subclass: #TelephoneBillingTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TelephoneBilling'!

!TelephoneBillingTest methodsFor: 'prices' stamp: 'SG 5/20/2024 00:15:56'!
priceReferences

	| pricePerMinuteTable |
	
	pricePerMinuteTable  := Dictionary new.
	pricePerMinuteTable add: #Uruguay -> (1*peso).
	pricePerMinuteTable add: #Misiones -> (5*peso).
	
	^pricePerMinuteTable ! !


!TelephoneBillingTest methodsFor: 'testing' stamp: 'SG 5/20/2024 00:23:33'!
test01TotalWithoutCallsIsMonthlyPayment

	| bill |
	
	bill := TelephoneBiller withMonthlyPayment: (100*peso) andCalls: #() andPrices: self priceReferences.
	
	self assert: (bill totalForMonth: (May, 2024)) = (100*peso)! !

!TelephoneBillingTest methodsFor: 'testing' stamp: 'SG 5/20/2024 00:26:04'!
test02InternationalCallsAreBilledAsExpected

	| bill internationalCall |
	
	internationalCall := InternationalCall from: #Uruguay on: (self aSaturdayDateTime) withDurationInMinutes: 1.
	bill := TelephoneBiller withMonthlyPayment: (100*peso) andCalls: (Array with: internationalCall) andPrices: self priceReferences.
	
	self assert: ((bill totalForMonth: (May, 2024)) = (101*peso))! !

!TelephoneBillingTest methodsFor: 'testing' stamp: 'SG 5/20/2024 00:32:24'!
test03NationalCallsAreBilledAsExpected

	| bill nationalCall |
	
	nationalCall := NationalCall from: #Misiones on: (self aSaturdayDateTime) withDurationInMinutes: 1.
	bill := TelephoneBiller withMonthlyPayment: (100*peso) andCalls: (Array with: nationalCall) andPrices: self priceReferences.
	
	self assert: ((bill totalForMonth: (May, 2024)) = (105*peso))! !

!TelephoneBillingTest methodsFor: 'testing' stamp: 'SG 5/20/2024 00:33:19'!
test04LocalCallsOnWeekendsAreBilledAsExpected

	| bill localCall |
	
	localCall := LocalCall on: (self aSaturdayDateTime) withDurationInMinutes: 1.
	bill := TelephoneBiller withMonthlyPayment: (100*peso) andCalls: (Array with: localCall) andPrices: self priceReferences.
	
	self assert: ((bill totalForMonth: (May, 2024)) = (100.1*peso))! !

!TelephoneBillingTest methodsFor: 'testing' stamp: 'SG 5/20/2024 01:15:24'!
test05LocalCallsOnWorkingDayWorkingHourAreBilledAsExpected

	| bill localCall |
	
	localCall := LocalCall on: (self aWorkingDayWorkingHourDateTime) withDurationInMinutes: 1.
	bill := TelephoneBiller withMonthlyPayment: (100*peso) andCalls: (Array with: localCall) andPrices: self priceReferences.
	
	self assert: ((bill totalForMonth: (May, 2024)) = (100.2*peso))! !

!TelephoneBillingTest methodsFor: 'testing' stamp: 'SG 5/20/2024 01:14:56'!
test06LocalCallsOnWorkingDayNonWorkingHourAreBilledAsExpected

	| bill localCall |
	
	localCall := LocalCall on: (self aWorkingDayNonWorkingHourDateTime ) withDurationInMinutes: 1.
	bill := TelephoneBiller withMonthlyPayment: (100*peso) andCalls: (Array with: localCall) andPrices: self priceReferences.
	
	self assert: ((bill totalForMonth: (May, 2024)) = (100.1*peso))! !


!TelephoneBillingTest methodsFor: 'dates' stamp: 'SG 5/20/2024 00:15:00'!
aSaturdayDateTime

	^(May fourth, 2024) atNoon. 

! !

!TelephoneBillingTest methodsFor: 'dates' stamp: 'SG 5/20/2024 00:15:09'!
aWorkingDayNonWorkingHourDateTime

	^(May sixth, 2024) atMidnight. ! !

!TelephoneBillingTest methodsFor: 'dates' stamp: 'SG 5/20/2024 00:15:13'!
aWorkingDayWorkingHourDateTime

	^(May sixth, 2024) atNoon. ! !


!classDefinition: #Call category: 'TelephoneBilling'!
Object subclass: #Call
	instanceVariableNames: 'location dateTime duration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TelephoneBilling'!

!Call methodsFor: 'initializing' stamp: 'SG 5/20/2024 00:35:26'!
initializeFrom: aLocation on: aDateTime withDurationInMinutes: aMinutesTimeSpan 
	location := aLocation.
	dateTime := aDateTime.
	duration := aMinutesTimeSpan.! !


!Call methodsFor: 'accessing' stamp: 'SG 5/16/2024 12:38:52'!
callLocation
	^location! !

!Call methodsFor: 'accessing' stamp: 'SG 5/20/2024 00:36:15'!
callMonth
	^dateTime monthOfYear. 
! !

!Call methodsFor: 'accessing' stamp: 'SG 5/20/2024 00:35:26'!
dateTime
	^dateTime! !

!Call methodsFor: 'accessing' stamp: 'SG 5/19/2024 19:53:13'!
duration
	^duration! !

!Call methodsFor: 'accessing' stamp: 'SG 5/19/2024 19:52:58'!
location
	^location! !


!Call methodsFor: 'testing' stamp: 'SG 5/20/2024 00:59:25'!
isLocalCall

	self subclassResponsibility! !

!Call methodsFor: 'testing' stamp: 'SG 5/20/2024 01:02:26'!
isOnWeekend
	^(self dateTime date isSaturday) or: (self dateTime date isSunday)! !

!Call methodsFor: 'testing' stamp: 'SG 5/20/2024 01:09:08'!
isWorkingHour
	^(dateTime timeOfDay > (08:00:00)) and: [dateTime timeOfDay < (20:00:00)]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Call class' category: 'TelephoneBilling'!
Call class
	instanceVariableNames: ''!

!Call class methodsFor: 'instance creation' stamp: 'SG 5/20/2024 01:47:35'!
from: aLocation on: aDateTime withDurationInMinutes: aMinuteTimeDuration

	^self new initializeFrom: aLocation on: aDateTime withDurationInMinutes: aMinuteTimeDuration ! !


!classDefinition: #InternationalCall category: 'TelephoneBilling'!
Call subclass: #InternationalCall
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TelephoneBilling'!

!InternationalCall methodsFor: 'testing' stamp: 'SG 5/20/2024 01:00:22'!
isLocalCall
	^false! !


!classDefinition: #LocalCall category: 'TelephoneBilling'!
Call subclass: #LocalCall
	instanceVariableNames: 'timeDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TelephoneBilling'!

!LocalCall methodsFor: 'initializing' stamp: 'SG 5/20/2024 00:35:26'!
initializeOn: aTimeDate withDurationInMinutes: aDuration 

	dateTime := aTimeDate.
	duration := aDuration.! !


!LocalCall methodsFor: 'testing' stamp: 'SG 5/20/2024 00:58:13'!
isLocalCall

	^true! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'LocalCall class' category: 'TelephoneBilling'!
LocalCall class
	instanceVariableNames: ''!

!LocalCall class methodsFor: 'instance creation' stamp: 'SG 5/19/2024 23:49:45'!
on: aTimeDate withDurationInMinutes: aDuration

	^self new initializeOn: aTimeDate withDurationInMinutes: aDuration ! !


!classDefinition: #NationalCall category: 'TelephoneBilling'!
Call subclass: #NationalCall
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TelephoneBilling'!

!NationalCall methodsFor: 'testing' stamp: 'SG 5/20/2024 01:00:29'!
isLocalCall
	^false! !


!classDefinition: #TelephoneBiller category: 'TelephoneBilling'!
Object subclass: #TelephoneBiller
	instanceVariableNames: 'monthlyPayment calls prices'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TelephoneBilling'!

!TelephoneBiller methodsFor: 'initializing' stamp: 'SG 5/20/2024 00:18:31'!
initializeWithMonthlyPayment: aMonthlyPayment andCalls: aCallList anPrices: aPriceReference  

	prices := aPriceReference.
	monthlyPayment := aMonthlyPayment.
	calls := aCallList.
! !


!TelephoneBiller methodsFor: 'billing' stamp: 'SG 5/20/2024 01:18:02'!
calculatePrice: aCall

	^(self callMultiplicator: aCall) * (aCall duration).
! !

!TelephoneBiller methodsFor: 'billing' stamp: 'SG 5/20/2024 01:44:49'!
calculateTotalCallsFor: aMonth

	| callsToBill callsTotal monthTotal |
	
	monthTotal := monthlyPayment.
	callsTotal := 0*peso.
	
	calls ifNotEmpty: [
	callsToBill := calls select: [:aCall | aCall callMonth = aMonth ].
	callsToBill ifNotEmpty: [	callsTotal := callsToBill sum: [:aCallToBill | self calculatePrice: aCallToBill]].
	monthTotal := monthTotal + callsTotal.
	 ].

	^monthTotal.
! !

!TelephoneBiller methodsFor: 'billing' stamp: 'SG 5/20/2024 01:17:08'!
callMultiplicator: aCall
	
	(aCall isLocalCall) ifTrue:[
		(aCall isOnWeekend) ifTrue: [		^0.1*peso].
		(aCall isWorkingHour) ifTrue: [^0.2*peso] ifFalse: [^0.1*peso]
	]

	ifFalse:[	^prices at: 	(aCall location)		]
	! !

!TelephoneBiller methodsFor: 'billing' stamp: 'SG 5/20/2024 00:54:09'!
isOnWeekend: aCall
	^(aCall dateTime date isSaturday) or: (aCall dateTime date isSunday)! !

!TelephoneBiller methodsFor: 'billing' stamp: 'SG 5/19/2024 23:07:36'!
totalForMonth: aMonth
	
	^self calculateTotalCallsFor: aMonth! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TelephoneBiller class' category: 'TelephoneBilling'!
TelephoneBiller class
	instanceVariableNames: ''!

!TelephoneBiller class methodsFor: 'instance creation' stamp: 'SG 5/19/2024 19:34:22'!
withMonthlyPayment: aMonthlyPayment andCalls: aCallList andPrices: aPriceReference  

	^self new initializeWithMonthlyPayment: aMonthlyPayment andCalls: aCallList anPrices: aPriceReference ! !
