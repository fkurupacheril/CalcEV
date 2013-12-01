//
//  CalcEVAppDelegate.m
//  CalcEV
//
//  Created by Francis Kurupacheril on 11/16/11.
//  Copyright 2011 __Altiora__. All rights reserved.
//

#import "AppDelegate.h"

@implementation CalcEVAppDelegate

@synthesize window;
@synthesize displayCar, displaySavings;
@synthesize displayModel, displayCash, displayGas, displayMiles, displayElec, displayTotalElec;

#pragma mark -
#pragma mark Application lifecycle


/*
 * Display functions for each slider movement
 */

-(void) processGasExpensesLabel:(float) gasExpenses
{
	NSString* myNewString = [NSString stringWithFormat:@"$%.2f", gasExpenses];
	[displayGas setText: myNewString];	
}

-(void) processElectricityExpensesLabel:(float) electricExpenses 
{
	NSString* myNewString = [NSString stringWithFormat:@"$%.2f", electricExpenses];
	[displayElec setText: myNewString];	
}

-(void) processTotalMilesDailyLabel:(float) totalMiles
{
	NSString* myNewString = [NSString stringWithFormat:@"%.2f", totalMiles];
    [displayMiles setText: myNewString];	
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    
    /*
     * Set all the initial values. 
     */
    
    cost_savings_per_month = INITIAL_COST_SAVINGS;
	average_breakeven_years = AVERAGE_BREAKEVEN_YEARS; // Ask Francis Kurupacheril if you wanna know how this was calculated :)
	total_current_savings = TOTAL_CURRENT_SAVINGS;
	average_charge_per_mile_cost = AVERAGE_CHARGE_PER_MILE_COST; // It costs around 3-5 cents to charge an EV for it to drive a mile
	self.displayCar = [NSMutableString stringWithCapacity: LENGTH_OF_DISPLAY_STRINGS];
	self.displaySavings = [NSMutableString stringWithCapacity: LENGTH_OF_DISPLAY_STRINGS];
    gasperMonth = INITIAL_GAS_PER_MONTH;
    milesperDay = INITIAL_MILES_PER_DAY;
    elecperMonth = INITIAL_ELEC_PER_MONTH;
    
    /*
     * Display the initial slider values.
     */
    
    [self processGasExpensesLabel:gasperMonth];
    [self processElectricityExpensesLabel:elecperMonth];
    [self processTotalMilesDailyLabel:milesperDay];
    
    /*
     * Boom - here we go !
     */
    [self.window makeKeyAndVisible];
    
    return YES;
}


/*
 * Assign values when the sliders are moved
 */

-(void) processGasExpensesPerMonth:(float) gasExpenses
{
	gasperMonth = gasExpenses ;
}

-(void) processElectricityExpensesPerMonth:(float) electricExpenses 
{
	elecperMonth = electricExpenses ;
}

-(void) processTotalMilesDrivenDaily:(float) totalMiles
{
	milesperDay = totalMiles ;
}


/*
 * Display the labels as they are calculated. 
 */
-(void)displayLabels:(NSString *)stringOne andSecond:(NSString *)stringTwo andThird:(NSString *)stringThree
{
    [displaySavings setString: stringOne];
    [displayCar setString: stringTwo];
    [displayCash setText: displaySavings];	
    [displayModel setText: displayCar];
    [displaySavings setString: stringThree];
    [displayTotalElec setText: displaySavings];
}

/*
 * The method that processes the button. 
 */

-(void) processAppropriateEV 
{
	total_current_savings = INITIAL_VALUE_SETTING ; 
	total_cost_to_charge_EV_per_month = AVERAGE_DAYS_PER_MONTH * milesperDay * average_charge_per_mile_cost;
	cost_savings_per_month = gasperMonth - total_cost_to_charge_EV_per_month;
	total_current_savings = cost_savings_per_month * average_breakeven_years;
	total_electricity_bill_per_month = total_cost_to_charge_EV_per_month + elecperMonth ;
	
	/*
	 * Display the correct messages depending on the ranges calculated above. May have to 
     * add more EV's and also correspondingly adjust the ranges.
	 */
	
	if (total_current_savings <= 0) {
        [self displayLabels:[NSString stringWithFormat:@"---------------Invalid entries----------------"] 
                  andSecond:[NSString stringWithFormat:@"Please use the sliders to set realistic values"]
                   andThird:[NSString stringWithFormat:@"All the three slider values have to make sense"]];
    }
    else if ((total_current_savings) > 0 && (total_current_savings < LEAST_COST_SAVINGS)) {
        [self displayLabels:[NSString stringWithFormat:@"Over 10 years, you save $%.2f.",total_current_savings] 
                  andSecond:[NSString stringWithFormat:@"This is insufficient to cover the retail cost"]
                   andThird:[NSString stringWithFormat:@"difference over a 4-door mid-size sedan"]];
	} 
    else if ((total_current_savings) > LEAST_COST_SAVINGS_NEEDED_FOR_TESLA) {
        [self displayLabels:[NSString stringWithFormat:@"1. Over 10 years, you save $%.2f",total_current_savings] 
                  andSecond:[NSString stringWithFormat:@"2. Your Affordable EV = Tesla Model S"]
                   andThird:[NSString stringWithFormat:@"3. New monthly Electric bill = $%.2f", total_electricity_bill_per_month]];
    } 
    else if ((total_current_savings >= LEAST_COST_SAVINGS_NEEDED_FOR_VOLT) && (total_current_savings < LEAST_COST_SAVINGS_NEEDED_FOR_FOCUS_ELECTRIC )) {
        [self displayLabels:[NSString stringWithFormat:@"1. Over 10 years, you save $%.2f",total_current_savings] 
                  andSecond:[NSString stringWithFormat:@"2. Your Affordable EV = Chevrolet Volt"]
                   andThird:[NSString stringWithFormat:@"3. New monthly Electric bill = $%.2f", total_electricity_bill_per_month]];
	} 
    else if ((total_current_savings >= LEAST_COST_SAVINGS_NEEDED_FOR_FOCUS_ELECTRIC) && (total_current_savings < LEAST_COST_SAVINGS_NEEDED_FOR_LEAF )) {
		[self displayLabels:[NSString stringWithFormat:@"1. Over 10 years, you save $%.2f",total_current_savings] 
                  andSecond:[NSString stringWithFormat:@"2. Your Affordable EV = Ford Focus Electric"]
                   andThird:[NSString stringWithFormat:@"3. New monthly Electric bill = $%.2f", total_electricity_bill_per_month]];
    }
    else if ((total_current_savings >= LEAST_COST_SAVINGS_NEEDED_FOR_LEAF) && (total_current_savings < LEAST_COST_SAVINGS_NEEDED_FOR_CODA )) {
        [self displayLabels:[NSString stringWithFormat:@"1. Over 10 years, you save $%.2f",total_current_savings] 
                  andSecond:[NSString stringWithFormat:@"2. Your Affordable EV = Nissan Leaf"]
                   andThird:[NSString stringWithFormat:@"3. New monthly Electric bill = $%.2f", total_electricity_bill_per_month]];
    }
    else if ((total_current_savings >= LEAST_COST_SAVINGS_NEEDED_FOR_CODA) && (total_current_savings < LEAST_COST_SAVINGS_NEEDED_FOR_TESLA )) {
        [self displayLabels:[NSString stringWithFormat:@"1. Over 10 years, you save $%.2f",total_current_savings] 
                  andSecond:[NSString stringWithFormat:@"2. Your Affordable EV = CODA Coda"]
                   andThird:[NSString stringWithFormat:@"3. New monthly Electric bill = $%.2f", total_electricity_bill_per_month]]; 
    } 
	
	total_current_savings = INITIAL_VALUE_SETTING ; 
	total_cost_to_charge_EV_per_month = INITIAL_VALUE_SETTING;
	cost_savings_per_month = INITIAL_VALUE_SETTING;
	total_electricity_bill_per_month = INITIAL_VALUE_SETTING;
}


-(IBAction) gasBar: (UISlider *) sender
{
	UISlider *slider = (UISlider*)sender;
    float sliderValue = [slider value];
	[self processGasExpensesPerMonth:sliderValue];
	[self processGasExpensesLabel:sliderValue];
}

-(IBAction) electricityBar: (UISlider *) sender
{
	UISlider *slider = (UISlider*)sender;
    float sliderValue = [slider value];
	[self processElectricityExpensesPerMonth:sliderValue];
	[self processElectricityExpensesLabel:sliderValue];
}

-(IBAction) milesBar: (UISlider *) sender
{
	UISlider *slider = (UISlider*)sender;
    float sliderValue = [slider value];
	[self processTotalMilesDrivenDaily:sliderValue];
	[self processTotalMilesDailyLabel:sliderValue];
}

-(IBAction) clickFindEV: (id) sender
{
	[self processAppropriateEV];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
     
}

@end