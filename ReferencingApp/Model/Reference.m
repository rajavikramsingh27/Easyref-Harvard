//
//  Reference.m
//  ReferencingApp
//
//  Created by Radu Mihaiu on 21/09/2014.
//  Copyright (c) 2014 SquaredDimesions. All rights reserved.
//

#import "Reference.h"


@implementation Reference

@dynamic data;
@dynamic projectID;
@dynamic referenceID;
@dynamic referenceType;
@dynamic dateCreated;


-(NSMutableAttributedString *)getReferenceString
{
    NSError *error;
    
    NSLog(@"%@",self.data);
    
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:[self.data dataUsingEncoding:NSUTF8StringEncoding] options:NSUTF8StringEncoding error:&error];
    NSMutableAttributedString *returnString;
    
    NSDictionary *normalAttribute = @{
                                      NSFontAttributeName : [UIFont fontWithName:@"MuseoSlab-500" size:12.0f],
                                      };

    NSDictionary *italicAttribute = @{
                                      NSFontAttributeName : [UIFont fontWithName:@"MuseoSlab-500Italic" size:12.0f],
                                      };
    
    if ([self.referenceType isEqualToString:@"Annual Report"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@ (%@) ",
                                [dataDict objectForKey:@"Corporate Author"],
                                [dataDict objectForKey:@"Year"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". %@: %@",[dataDict objectForKey:@"Place of Publication"],[dataDict objectForKey:@"Publisher"]] attributes:normalAttribute]];
    }
    if ([self.referenceType isEqualToString:@"Audio CD"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@ (%@) ",
                                [dataDict objectForKey:@"Artist"],
                                [dataDict objectForKey:@"Year"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" [CD] %@: %@",[dataDict objectForKey:@"Place of Distribution"],[dataDict objectForKey:@"Distribution Company"]] attributes:normalAttribute]];
    }
    if ([self.referenceType isEqualToString:@"Blog"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Blog Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@, %@. (%@) %@, ",
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Initials"],
                                [dataDict objectForKey:@"Year"],
                                [dataDict objectForKey:@"Title of blog entry"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". [Blog] %@. Available at %@ [Accessed %@].",[dataDict objectForKey:@"Date of Post"],[dataDict objectForKey:@"URL"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
    }
    if ([self.referenceType isEqualToString:@"Book"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Title"] attributes:italicAttribute];
        
        NSString *baseString = @"";
        for (int i = 0; i < [[dataDict objectForKey:@"Author Double Field"] count]; i ++)
        {
            NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:i];
            
            if (i == [[dataDict objectForKey:@"Author Double Field"] count] - 1 && i != 0)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"and %@, %@. ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
            
            else if ([[dataDict objectForKey:@"Author Double Field"] count] == 1)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@. ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
            
            else
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@., ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
        }
    
        
        if ([[dataDict objectForKey:@"hasEditors"] intValue] == TRUE)
        {
            if ([[dataDict objectForKey:@"Author Double Field"] count] > 1)
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"eds. (%@) ",[dataDict objectForKey:@"Year"]]];
            else
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"ed. (%@) ",[dataDict objectForKey:@"Year"]]];
        }
        else
            baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"(%@) ",[dataDict objectForKey:@"Year"]]];
        
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        
        if ([[dataDict objectForKey:@"Edition"] isEqualToString:@""])
        {
            [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". %@: %@.",[dataDict objectForKey:@"Place of Publication"],[dataDict objectForKey:@"Publisher"]] attributes:normalAttribute]];
        }
        else
        {
        
            [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". %@ edn. %@: %@.",[dataDict objectForKey:@"Edition"],[dataDict objectForKey:@"Place of Publication"],[dataDict objectForKey:@"Publisher"]] attributes:normalAttribute]];
            
        }
        
    }
    if ([self.referenceType isEqualToString:@"Book No Author"])
    {
        returnString = [[NSMutableAttributedString alloc] initWithString:[dataDict objectForKey:@"Title"] attributes:italicAttribute];
        
        NSString *baseString = @"";
        baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@". %@",[dataDict objectForKey:@"Year"]]];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:baseString attributes:@{}]];

        if ([[dataDict objectForKey:@"Edition"] isEqualToString:@""])
        {
            [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". %@: %@.",[dataDict objectForKey:@"Place of Publication"],[dataDict objectForKey:@"Publisher"]] attributes:normalAttribute]];
        }
        else
        {
            
            [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". %@ edn. %@: %@.",[dataDict objectForKey:@"Edition"],[dataDict objectForKey:@"Place of Publication"],[dataDict objectForKey:@"Publisher"]] attributes:normalAttribute]];
        }
        
    }

    if ([self.referenceType isEqualToString:@"Book Online"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Title"] attributes:italicAttribute];
        
        NSString *baseString = @"";
        for (int i = 0; i < [[dataDict objectForKey:@"Author Double Field"] count]; i ++)
        {
            NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:i];
            
            if (i == [[dataDict objectForKey:@"Author Double Field"] count] - 1 && i != 0)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"and %@, %@. ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
            
            else if ([[dataDict objectForKey:@"Author Double Field"] count] == 1)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@. ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
            
            else
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@., ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
        }
        
        baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"(%@) ",[dataDict objectForKey:@"Year"]]];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" [online]. %@: %@. Available at http://%@ [Accessed %@].",[dataDict objectForKey:@"Place of Publication"],[dataDict objectForKey:@"Publisher"],[dataDict objectForKey:@"URL"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
        
    }
    
    if ([self.referenceType isEqualToString:@"Dissertation"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@, %@. (%@) ",
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Initials"],
                                [dataDict objectForKey:@"Year"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". %@ Dissertation. %@: %@.",[dataDict objectForKey:@"Level"],[dataDict objectForKey:@"Place of University"],[dataDict objectForKey:@"Name of University"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Dissertation Online"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@, %@. (%@) ",
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Initials"],
                                [dataDict objectForKey:@"Year"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". %@ Dissertation. %@: %@. Available at <%@> [Accessed %@].",[dataDict objectForKey:@"Level"],[dataDict objectForKey:@"Place of University"],[dataDict objectForKey:@"Name of University"],[dataDict objectForKey:@"URL"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
        
    }
    
    
    
    if ([self.referenceType isEqualToString:@"Email"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Subject"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@, %@. (%@) ",
                                [dataDict objectForKey:@"Sender's Surname"],
                                [dataDict objectForKey:@"Sender's Initial"],
                                [dataDict objectForKey:@"Year"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" [Email] to %@. [Accessed %@].",[dataDict objectForKey:@"Recipient"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Encyclopedia"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Encyclopedia Title"] attributes:italicAttribute];
        
        NSString *baseString = @"";
        for (int i = 0; i < [[dataDict objectForKey:@"Author Double Field"] count]; i ++)
        {
            NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:i];
            
            if (i == [[dataDict objectForKey:@"Author Double Field"] count] - 1 && i != 0)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"and %@, %@. ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
            
            else if ([[dataDict objectForKey:@"Author Double Field"] count] == 1)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@. ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
            
            else
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@., ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
        }
        
        
        if ([[dataDict objectForKey:@"hasEditors"] intValue] == TRUE)
        {
            if ([[dataDict objectForKey:@"Author Double Field"] count] > 1)
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"eds. (%@) '%@'. in ",[dataDict objectForKey:@"Year"],[dataDict objectForKey:@"Entry Title"]]];
            else
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"ed. (%@) '%@'. in ",[dataDict objectForKey:@"Year"],[dataDict objectForKey:@"Entry Title"]]];
        }
        else
            baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"(%@) '%@'. in ",[dataDict objectForKey:@"Year"],[dataDict objectForKey:@"Entry Title"]]];
        
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        if ([[dataDict objectForKey:@"Edition"] isEqualToString:@""])
        {
            [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". Vol %@. %@: %@, pp.%@.",[dataDict objectForKey:@"Volume"],[dataDict objectForKey:@"Place of Publication"],[dataDict objectForKey:@"Publisher"],[dataDict objectForKey:@"Pages"]] attributes:normalAttribute]];
            
        }
        else
        {
            [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". %@ edn. Vol %@. %@: %@, pp.%@.",[dataDict objectForKey:@"Edition"],[dataDict objectForKey:@"Volume"],[dataDict objectForKey:@"Place of Publication"],[dataDict objectForKey:@"Publisher"],[dataDict objectForKey:@"Pages"]] attributes:normalAttribute]];
            
        }
    }
    
    if ([self.referenceType isEqualToString:@"Encyclopedia Online"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Encyclopedia Title"] attributes:italicAttribute];
        
        NSString *baseString = @"";
        for (int i = 0; i < [[dataDict objectForKey:@"Author Double Field"] count]; i ++)
        {
            NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:i];
            
            if (i == [[dataDict objectForKey:@"Author Double Field"] count] - 1 && i != 0)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"and %@, %@. (%@) '%@'. in ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"],[dataDict objectForKey:@"Year"],[dataDict objectForKey:@"Entry Title"]]];
            }
            
            else if ([[dataDict objectForKey:@"Author Double Field"] count] == 1)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@. (%@) '%@'. in ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"],[dataDict objectForKey:@"Year"],[dataDict objectForKey:@"Entry Title"]]];
            }
            
            else
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@., (%@) '%@'. in ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"],[dataDict objectForKey:@"Year"],[dataDict objectForKey:@"Entry Title"]]];
            }
        }
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        
        if ([[dataDict objectForKey:@"Edition"] isEqualToString:@""])
        {
            [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". Vol %@. [online] %@: %@. Available at <%@> [Accessed %@].",[dataDict objectForKey:@"Volume"],[dataDict objectForKey:@"Place of Publication"],[dataDict objectForKey:@"Publisher"],[dataDict objectForKey:@"URL"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
            
        }
        else
        {
            [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". %@ edn. Vol %@. [Online] %@: %@. Available at <%@> [Accessed %@].",[dataDict objectForKey:@"Edition"],[dataDict objectForKey:@"Volume"],[dataDict objectForKey:@"Place of Publication"],[dataDict objectForKey:@"Publisher"],[dataDict objectForKey:@"URL"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
            
        }
    }
    
    
    if ([self.referenceType isEqualToString:@"Film"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Country of origin"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@, %@. (%@) Directed by %@. ",
                                [dataDict objectForKey:@"Title"],
                                [dataDict objectForKey:@"Year"],
                                [dataDict objectForKey:@"Type of medium"],
                                [dataDict objectForKey:@"Director"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@": %@.",[dataDict objectForKey:@"Film studio"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Gov Document"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@ (%@) ",
                                [dataDict objectForKey:@"Authorship"],
                                [dataDict objectForKey:@"Year"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". %@: %@.",[dataDict objectForKey:@"Place of Publication"],[dataDict objectForKey:@"Publisher"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Image"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Title of Image"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@. (%@) ",
                                [dataDict objectForKey:@"Originator/Artist"],
                                [dataDict objectForKey:@"Year of Distribution"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" [online] %@. Available at <%@> [Accessed %@].",[dataDict objectForKey:@"Date of Image"],[dataDict objectForKey:@"Image URL"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Interview"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Interview Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@, %@. (%@) ",
                                [dataDict objectForKey:@"Interviewee's Surname"],
                                [dataDict objectForKey:@"Interviewee's Initials"],
                                [dataDict objectForKey:@"Year"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". Interviewed by %@ [%@] %@.",[dataDict objectForKey:@"Interviewer"],[dataDict objectForKey:@"Type of Interview"],[dataDict objectForKey:@"Date of Transmission"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Journal"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Journal Title"] attributes:italicAttribute];
        
        NSString *baseString = @"";
        for (int i = 0; i < [[dataDict objectForKey:@"Author Double Field"] count]; i ++)
        {
            NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:i];
            
            if (i == [[dataDict objectForKey:@"Author Double Field"] count] - 1 && i != 0)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"and %@, %@. ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
            
            else if ([[dataDict objectForKey:@"Author Double Field"] count] == 1)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@. ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
            
            else
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@., ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
        }
        
        if ([[dataDict objectForKey:@"hasEditors"] intValue] == TRUE)
        {
            if ([[dataDict objectForKey:@"Author Double Field"] count] > 1)
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"eds. (%@) '%@'. ",[dataDict objectForKey:@"Year"],[dataDict objectForKey:@"Article Title"]]];
            else
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"ed. (%@) '%@'. ",[dataDict objectForKey:@"Year"],[dataDict objectForKey:@"Article Title"]]];
            
        }
        else
            baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"(%@) '%@'. ",[dataDict objectForKey:@"Year"],[dataDict objectForKey:@"Article Title"]]];
        

        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        
        if ([[dataDict objectForKey:@"Issue"] isEqualToString:@""])
            
        {
             [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@, pp.%@.",[dataDict objectForKey:@"Volume"],[dataDict objectForKey:@"Pages Used"]] attributes:normalAttribute]];
        }
        else
        {
            
             [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ (%@), pp.%@.",[dataDict objectForKey:@"Volume"],[dataDict objectForKey:@"Issue"],[dataDict objectForKey:@"Pages Used"]] attributes:normalAttribute]];
            
        }

        
        
       // [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@, (%@) %@.",[dataDict objectForKey:@"Volume"],[dataDict objectForKey:@"Issue"],[dataDict objectForKey:@"Pages Used"]] attributes:normalAttribute]];
        
    }
    
    
    if ([self.referenceType isEqualToString:@"Journal Online"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Journal Title"] attributes:italicAttribute];
        
        NSString *baseString = @"";
        for (int i = 0; i < [[dataDict objectForKey:@"Author Double Field"] count]; i ++)
        {
            NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:i];
            
            if (i == [[dataDict objectForKey:@"Author Double Field"] count] - 1 && i != 0)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"and %@, %@. ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
            
            else if ([[dataDict objectForKey:@"Author Double Field"] count] == 1)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@. ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
            
            else
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@., ",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
        }
        
        baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@" (%@) '%@'. ",[dataDict objectForKey:@"Year"],[dataDict objectForKey:@"Article Title"]]];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        
        if ([[dataDict objectForKey:@"Issue"] isEqualToString:@""])
            
        {
            [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" [online] %@, pp.%@. Available at <%@> [Accessed %@]",[dataDict objectForKey:@"Volume"],[dataDict objectForKey:@"Pages Used"],[dataDict objectForKey:@"Website"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
        }
        else
        {
            
            [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" [online] %@, (%@) pp.%@. Available at <%@> [Accessed %@]",[dataDict objectForKey:@"Volume"],[dataDict objectForKey:@"Issue"],[dataDict objectForKey:@"Pages Used"],[dataDict objectForKey:@"Website"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
            
        }
        
    }

    if ([self.referenceType isEqualToString:@"Kindle"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Title"] attributes:italicAttribute];
        
        NSString *baseString = @"";
        for (int i = 0; i < [[dataDict objectForKey:@"Author Double Field"] count]; i ++)
        {
            NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:i];
            
            if (i == [[dataDict objectForKey:@"Author Double Field"] count] - 1 && i != 0)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"and %@, %@.",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
            
            else if ([[dataDict objectForKey:@"Author Double Field"] count] == 1)
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@.",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
            
            else
            {
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@.,",[authorDict objectForKey:@"Surname"],[authorDict objectForKey:@"Initials"]]];
            }
        }
        
        baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@" (%@) ",[dataDict objectForKey:@"Year"]]];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" [Kindle Version] Available at <%@> [Accessed %@].",[dataDict objectForKey:@"URL"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Map"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@, %@. (%@) ",
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Initials"],
                                [dataDict objectForKey:@"Year"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". %@. %@: %@.",[dataDict objectForKey:@"Scale"],[dataDict objectForKey:@"Place of Publication"],[dataDict objectForKey:@"Publisher"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Mobile App"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"App Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@ (%@) ",
                                [dataDict objectForKey:@"Development Company"],
                                [dataDict objectForKey:@"Year"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (Version %@) [Mobile Application] Available at <%@> [Accessed %@].",[dataDict objectForKey:@"Version Number"],[dataDict objectForKey:@"URL"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Newspaper"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Article Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@, %@. (%@) '",
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Initials"],
                                [dataDict objectForKey:@"Year Published"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"'. %@. %@, %@.",[dataDict objectForKey:@"Newspaper"],[dataDict objectForKey:@"Date/Month"],[dataDict objectForKey:@"Page used"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Newspaper Online"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Article Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@, %@. (%@) '",
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Initials"],
                                [dataDict objectForKey:@"Year Published"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"'. %@. [online] %@. Available at <%@> [Accessed %@].",[dataDict objectForKey:@"Newspaper"],[dataDict objectForKey:@"Date/Month"],[dataDict objectForKey:@"URL"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
        
    }
    
    if ([self.referenceType isEqualToString:@"PDF"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@. (%@) ",
                                [dataDict objectForKey:@"Authorship"],
                                [dataDict objectForKey:@"Year"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" [online] %@: %@. Available at <%@> [Accessed %@]",[dataDict objectForKey:@"Place of Publication"],[dataDict objectForKey:@"Publisher"],[dataDict objectForKey:@"URL"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Podcast"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Episode Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@, %@. (%@) ",
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Initials"],
                                [dataDict objectForKey:@"Year"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@", %@. [Podcast] %@. Available at <%@> [Accessed %@].",[dataDict objectForKey:@"Podcast Title"],[dataDict objectForKey:@"Date of Post"],[dataDict objectForKey:@"URL"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Powerpoint"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@, %@. (%@) ",
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],
                                [[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Initials"],
                                [dataDict objectForKey:@"Year"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" [Presentation] Available at <%@> [Accessed %@].",[dataDict objectForKey:@"URL"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Video"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[dataDict objectForKey:@"Title of Video"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@. (%@). ",
                                [dataDict objectForKey:@"Originator/Artist"],
                                [dataDict objectForKey:@"Year of Distribution"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@". [online video] %@. Available at <%@> [Accessed %@].",[dataDict objectForKey:@"Date of Video"],[dataDict objectForKey:@"Video URL"],[dataDict objectForKey:@"Accessed Date"]] attributes:normalAttribute]];
        
    }
    if ([self.referenceType isEqualToString:@"Website"])
    {
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString: (NSString *)[dataDict objectForKey:@"Title"] attributes:italicAttribute];
        
        NSString *baseString = [NSString stringWithFormat:@"%@ (%@) ",
                                (NSString *)[dataDict objectForKey:@"Name of Website/Author"],
                                [dataDict objectForKey:@"Year"]
                                ];
        
        returnString = [[NSMutableAttributedString alloc] initWithString:baseString attributes:normalAttribute];
        [returnString appendAttributedString:titleString];
        [returnString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" [online] Available at <%@> [Accessed %@].",[dataDict objectForKey:@"URL"],[dataDict objectForKey:@"Last Accessed"]] attributes:normalAttribute]];
        
    }

    return returnString;
}

-(NSString *)getShortReferenceString
{
  NSError *error;
  NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:[self.data dataUsingEncoding:NSUTF8StringEncoding] options:NSUTF8StringEncoding error:&error];
  
  
  if ([self.referenceType isEqualToString:@"Annual Report"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",[dataDict objectForKey:@"Corporate Author"],[dataDict objectForKey:@"Year"]];
  }
  if ([self.referenceType isEqualToString:@"Audio CD"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",[dataDict objectForKey:@"Artist"],[dataDict objectForKey:@"Year"]];
  }
  if ([self.referenceType isEqualToString:@"Blog"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",[[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],[dataDict objectForKey:@"Year"]];
  }
    
    
    
  if ([self.referenceType isEqualToString:@"Book"])
  {
      NSString *baseString = @"";
      NSArray *authorArray = [dataDict objectForKey:@"Author Double Field"];
      
      // one author
      if ([authorArray count] == 1) {
          NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
          baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@,",[authorDict objectForKey:@"Surname"]]];
      }
      // more than 3
      else if ([authorArray count] >= 4) {
          NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
          baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, et al.,",[authorDict objectForKey:@"Surname"]]];
      }
      else if ([authorArray count] == 3) {
           NSDictionary *firstAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
           NSDictionary *secondAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:1];
          NSDictionary *thirdAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:2];
          baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@, and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"],[thirdAuthorDict objectForKey:@"Surname"]]];
      }
      // 2 or 3
      else if ([authorArray count] == 2)
          {
              NSDictionary *firstAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
                 NSDictionary *secondAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:1];
              baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@ and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"]]];
          
          }
         
      
    return [NSString stringWithFormat:@"(%@ %@)",baseString,[dataDict objectForKey:@"Year"]];
  }
    
    
    
    if ([self.referenceType isEqualToString:@"Book No Author"])
    {
        return [NSString stringWithFormat:@"(%@, %@). ",[dataDict objectForKey:@"Title"],[dataDict objectForKey:@"Year"]];
    }
    
    
    if ([self.referenceType isEqualToString:@"Book Online"])
    {
        NSString *baseString = @"";
        NSArray *authorArray = [dataDict objectForKey:@"Author Double Field"];
        
        // one author
        if ([authorArray count] == 1) {
            NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
            baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@,",[authorDict objectForKey:@"Surname"]]];
        }
        // more than 3
        else if ([authorArray count] >= 4) {
            NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
            baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, et al.,",[authorDict objectForKey:@"Surname"]]];
        }
        // 2 or 3
        else {
            NSDictionary *firstAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
            NSDictionary *secondAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:1];
            
            if ([authorArray count] == 2)
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@ and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"]]];
            
            
            else if ([authorArray count] == 3) {
                NSDictionary *thirdAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:2];
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@, and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"],[thirdAuthorDict objectForKey:@"Surname"]]];
                
            }
        }
        return [NSString stringWithFormat:@"(%@ %@)",baseString,[dataDict objectForKey:@"Year"]];
    }
    
    
    
    
  if ([self.referenceType isEqualToString:@"Dissertation"])
  {
      return [NSString stringWithFormat:@"(%@, %@)",[[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],[dataDict objectForKey:@"Year"]];
      
  }
    
    if ([self.referenceType isEqualToString:@"Dissertation Online"])
    {
        return [NSString stringWithFormat:@"(%@, %@)",[[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],[dataDict objectForKey:@"Year"]];
        
    }
    
    
  if ([self.referenceType isEqualToString:@"Email"])
  {
    return [NSString stringWithFormat:@"(%@, %@)", [dataDict objectForKey:@"Sender's Surname"],
            [dataDict objectForKey:@"Year"]];
    
  }
  if ([self.referenceType isEqualToString:@"Encyclopedia"])
  {
      NSString *baseString = @"";
      NSArray *authorArray = [dataDict objectForKey:@"Author Double Field"];
      
      // one author
      if ([authorArray count] == 1) {
          NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
          baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@,",[authorDict objectForKey:@"Surname"]]];
      }
      // more than 3
      else if ([authorArray count] >= 4) {
          NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
          baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, et al.,",[authorDict objectForKey:@"Surname"]]];
      }
      // 2 or 3
      else {
          NSDictionary *firstAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
          NSDictionary *secondAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:1];
          
          if ([authorArray count] == 2)
              baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@ and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"]]];
          
          
          else if ([authorArray count] == 3) {
              NSDictionary *thirdAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:2];
              baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@, and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"],[thirdAuthorDict objectForKey:@"Surname"]]];
              
          }
      }
      return [NSString stringWithFormat:@"(%@ %@)",baseString,[dataDict objectForKey:@"Year"]];
  }
    
    if ([self.referenceType isEqualToString:@"Encyclopedia Online"])
    {
        NSString *baseString = @"";
        NSArray *authorArray = [dataDict objectForKey:@"Author Double Field"];
        
        // one author
        if ([authorArray count] == 1) {
            NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
            baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@,",[authorDict objectForKey:@"Surname"]]];
        }
        // more than 3
        else if ([authorArray count] >= 4) {
            NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
            baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, et al.,",[authorDict objectForKey:@"Surname"]]];
        }
        // 2 or 3
        else {
            NSDictionary *firstAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
            NSDictionary *secondAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:1];
            
            if ([authorArray count] == 2)
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@ and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"]]];
            
            
            else if ([authorArray count] == 3) {
                NSDictionary *thirdAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:2];
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@, and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"],[thirdAuthorDict objectForKey:@"Surname"]]];
                
            }
        }
        return [NSString stringWithFormat:@"(%@ %@)",baseString,[dataDict objectForKey:@"Year"]];
    }
    
  if ([self.referenceType isEqualToString:@"Film"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",[dataDict objectForKey:@"Title"],[dataDict objectForKey:@"Year"]];
    
  }
  if ([self.referenceType isEqualToString:@"Gov Document"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",[dataDict objectForKey:@"Authorship"],[dataDict objectForKey:@"Year"]];
    
  }
  if ([self.referenceType isEqualToString:@"Image"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",[dataDict objectForKey:@"Originator/Artist"],
            [dataDict objectForKey:@"Year of Distribution"]];
    
  }
  if ([self.referenceType isEqualToString:@"Interview"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",[dataDict objectForKey:@"Interviewee's Surname"],
            [dataDict objectForKey:@"Year"]];
    
  }
  if ([self.referenceType isEqualToString:@"Journal"])
  {
      NSString *baseString = @"";
      NSArray *authorArray = [dataDict objectForKey:@"Author Double Field"];
      
      // one author
      if ([authorArray count] == 1) {
          NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
          baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@,",[authorDict objectForKey:@"Surname"]]];
      }
      // more than 3
      else if ([authorArray count] >= 4) {
          NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
          baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, et al.,",[authorDict objectForKey:@"Surname"]]];
      }
      // 2 or 3
      else {
          NSDictionary *firstAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
          NSDictionary *secondAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:1];
          
          if ([authorArray count] == 2)
              baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@ and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"]]];
          
          
          else if ([authorArray count] == 3) {
              NSDictionary *thirdAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:2];
              baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@, and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"],[thirdAuthorDict objectForKey:@"Surname"]]];
              
          }
      }
      return [NSString stringWithFormat:@"(%@ %@)",baseString,[dataDict objectForKey:@"Year"]];
  }
    
    if ([self.referenceType isEqualToString:@"Journal Online"])
    {
        NSString *baseString = @"";
        NSArray *authorArray = [dataDict objectForKey:@"Author Double Field"];
        
        // one author
        if ([authorArray count] == 1) {
            NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
            baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@,",[authorDict objectForKey:@"Surname"]]];
        }
        // more than 3
        else if ([authorArray count] >= 4) {
            NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
            baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, et al.,",[authorDict objectForKey:@"Surname"]]];
        }
        // 2 or 3
        else {
            NSDictionary *firstAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
            NSDictionary *secondAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:1];
            
            if ([authorArray count] == 2)
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@ and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"]]];
            
            
            else if ([authorArray count] == 3) {
                NSDictionary *thirdAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:2];
                baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@, and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"],[thirdAuthorDict objectForKey:@"Surname"]]];
                
            }
        }
        return [NSString stringWithFormat:@"(%@ %@)",baseString,[dataDict objectForKey:@"Year"]];
    }
    
    
  if ([self.referenceType isEqualToString:@"Kindle"])
  {
      NSString *baseString = @"";
      NSArray *authorArray = [dataDict objectForKey:@"Author Double Field"];
      
      // one author
      if ([authorArray count] == 1) {
          NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
          baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@,",[authorDict objectForKey:@"Surname"]]];
      }
      // more than 3
      else if ([authorArray count] >= 4) {
          NSDictionary *authorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
          baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, et al.,",[authorDict objectForKey:@"Surname"]]];
      }
      // 2 or 3
      else {
          NSDictionary *firstAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0];
          NSDictionary *secondAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:1];
          
          if ([authorArray count] == 2)
              baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@ and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"]]];
          
          
          else if ([authorArray count] == 3) {
              NSDictionary *thirdAuthorDict = [[dataDict objectForKey:@"Author Double Field"] objectAtIndex:2];
              baseString = [baseString stringByAppendingString:[NSString stringWithFormat:@"%@, %@, and %@,",[firstAuthorDict objectForKey:@"Surname"],[secondAuthorDict objectForKey:@"Surname"],[thirdAuthorDict objectForKey:@"Surname"]]];
              
          }
      }
      return [NSString stringWithFormat:@"(%@ %@)",baseString,[dataDict objectForKey:@"Year"]];
  }
    
    
  if ([self.referenceType isEqualToString:@"Map"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",[[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],[dataDict objectForKey:@"Year"]];
  }
  if ([self.referenceType isEqualToString:@"Mobile App"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",  [dataDict objectForKey:@"Development Company"],
            [dataDict objectForKey:@"Year"]];
    
  }
  if ([self.referenceType isEqualToString:@"Newspaper"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",[[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],[dataDict objectForKey:@"Year Published"]];
    
  }
    if ([self.referenceType isEqualToString:@"Newspaper Online"])
        
    {
        return [NSString stringWithFormat:@"(%@, %@)",[[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],[dataDict objectForKey:@"Year Published"]];
    }
    
  if ([self.referenceType isEqualToString:@"PDF"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",[dataDict objectForKey:@"Authorship"],[dataDict objectForKey:@"Year"]];
    
  }
  if ([self.referenceType isEqualToString:@"Podcast"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",[[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],[dataDict objectForKey:@"Year"]];
  }
  if ([self.referenceType isEqualToString:@"Powerpoint"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",[[[dataDict objectForKey:@"Author Double Field"] objectAtIndex:0] objectForKey:@"Surname"],[dataDict objectForKey:@"Year"]];
    
  }
  if ([self.referenceType isEqualToString:@"Video"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",  [dataDict objectForKey:@"Originator/Artist"],
            [dataDict objectForKey:@"Year of Distribution"]];
    
  }
  if ([self.referenceType isEqualToString:@"Website"])
  {
    return [NSString stringWithFormat:@"(%@, %@)",  [dataDict objectForKey:@"Name of Website/Author"],
            [dataDict objectForKey:@"Year"]];
    
  }
  
  return @"";
  
}


@end
