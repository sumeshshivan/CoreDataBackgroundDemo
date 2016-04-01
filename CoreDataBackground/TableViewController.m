//
//  TableViewController.m
//  CoreDataBackground
//
//  Created by Sumesh on 17/03/16.
//  Copyright © 2016 Sumesh. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()
{
    NSMutableArray *products;
}

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedManager] managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Product"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    [managedObjectContext executeRequest:delete error:nil];
    
    [self loadProducts];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductCell" forIndexPath:indexPath];
    
    NSManagedObject *product = [products objectAtIndex:indexPath.row];

    [cell.textLabel setText:[product valueForKey:@"name"]];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addProduct:(id)sender {
    
    NSManagedObjectContext *context = [[DataManager sharedManager] backgroundManagedObjectContext];
    for (int i=0; i<100000; i++) {
        [context performBlock:^(){
            NSManagedObject *newproduct = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
            [newproduct setValue:@"dummy product" forKey:@"name"];
            
        }];
    }
    [[DataManager sharedManager] saveBackgroundContext];
    [self loadProducts];
}

- (void)loadProducts {
    
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Product"];
    
    products = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}

- (IBAction)reload:(id)sender {
    NSLog(@"Reloading Data");
    [self loadProducts];
}
@end
