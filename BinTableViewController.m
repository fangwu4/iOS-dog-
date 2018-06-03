//
//  BinTableViewController.m
//  UI
//
//  Created by hha6027875 on 29/3/18.
//  Copyright © 2018 hha6027875. All rights reserved.
//

#import "BinTableViewController.h"
#import "BinGroup.h"
#import "BinDog.h"
#import "BinShowViewController.h"
@interface BinTableViewController ()
@property (nonatomic, strong)NSArray* groups;
@end

@implementation BinTableViewController

-(NSArray *)groups
{
    if(_groups == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"dogs1.plist" ofType:nil];
        NSArray * arrayDict = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *arrayModels = [NSMutableArray array];
        for(NSDictionary *dict in arrayDict)
        {
            BinGroup * model = [BinGroup groupWithDict:dict];
            [arrayModels addObject:model];
        }
        _groups = arrayModels;
    }
    return _groups;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dogs1.plist" ofType:nil];
    NSArray * arrayDict = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *arrayModels = [NSMutableArray array];
    for(NSDictionary *dict in arrayDict)
    {
        BinGroup * model = [BinGroup groupWithDict:dict];
        [arrayModels addObject:model];
    }
    self.groups = arrayModels;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    BinGroup *group = self.groups[section];
    return group.dogs.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BinGroup *group = self.groups[indexPath.section];
    BinDog *dog = group.dogs[indexPath.row];
    static NSString * ID = @"dog_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    cell.imageView.image = [UIImage imageNamed:dog.bimgf];
    CGSize size1 = CGSizeMake(40, 40);
    UIGraphicsBeginImageContext(size1);
    CGRect imageRect = CGRectMake(0.0, 0.0, size1.width, size1.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.textLabel.text = dog.name;
    cell.detailTextLabel.text = dog.detail;
    
    
    return cell;
}

-(NSArray * )sectionIndexTitlesForTableView:(UITableView *) tableView
{
    return [self.groups valueForKey: @"title"];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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



// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
        BinShowViewController * target = segue.destinationViewController;
        NSIndexPath * indexP = [self.tableView indexPathForSelectedRow];
        BinGroup *group = self.groups[indexP.section];
        BinDog *dogs = group.dogs[indexP.row];
    
        target.dogs = dogs;

    }


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self performSegueWithIdentifier:@"toShows" sender:nil];
}



















@end
