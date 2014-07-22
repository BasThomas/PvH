//
//  PVHTimeTableTableViewController.m
//  PvHApp
//
//  Created by Arnold Broek on 10/04/14.
//  Copyright (c) 2014 Bas Broek. All rights reserved.
//

#import "PVHTimeTableTableViewController.h"
#import "DetailViewController.h"
#import "BTBAppDelegate.h"

@interface PVHTimeTableTableViewController ()

@property (nonatomic)NSURLSession *session;

@property (nonatomic)BTBAppDelegate *appDelegate;

@end

@implementation PVHTimeTableTableViewController

//NSArray *tableData;
NSMutableArray *tableData;

- (void)viewWillAppear:(BOOL)animated
{
    self.appDelegate = (BTBAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.title = @"PvH App";
    tableData = [[NSMutableArray alloc] init];
    [self setSession];
    [self JSONFromURL];
}

- (void)setSession
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:config
                                             delegate:nil
                                        delegateQueue:nil];
}

- (void)JSONFromURL
{
    NSString *requestString = @"http://mauricevanbreukelen.nl/roosters/api/api.php?action=getTimeTable&student=132912&week=15&day=1";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSString *json = [[NSString alloc] initWithData:data
                                                                                 encoding:NSUTF8StringEncoding];
                                          [self JSONToObject:json data:data];
                                          
                                      }];
    [dataTask resume];
}

- (void)JSONToObject:(NSString *)json data:(NSData *)data
{
    //NSLog(@"%@", json);
    
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:nil];
    //NSLog(@"%@", jsonObject);
    if([jsonObject[@"status"] isEqual: @"OK"])
    {
        self.appDelegate.currentUser.firstName = jsonObject[@"name"][@"firstname"];
        self.appDelegate.currentUser.lastName = jsonObject[@"name"][@"lastname"];
        
        //NSLog(@"%@", jsonObject[@"lessons"]);
        
        for (id key in jsonObject[@"lessons"]) {
            NSString *testje = [NSString stringWithFormat:@"%@. %@", key[@"hour"], key[@"subject"]];

            [tableData addObject:testje];
            //[tableData addObject:key[@"hour"]];
        }
        
        NSLog(@"%lu", (unsigned long)[tableData count]);
    }
    
    //[self.tableView reloadData];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];*/

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Geklikt");
    NSLog(@"%ld", (long)indexPath.row);
    NSLog(@"%@", [tableData objectAtIndex:indexPath.row]);
    [self performSegueWithIdentifier:@"OpenHour" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"OpenHour"])
    {
        //DetailViewController *detailView = [[DetailViewController alloc] init];
        DetailViewController *detailView = (DetailViewController *)[segue destinationViewController];
        detailView.subject = @"De subject";
    }
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
