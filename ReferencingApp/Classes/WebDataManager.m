//
//  WebDataManager.m
//  EasyRef
//
//  Created by Kashif Junaid on 10/05/2018.
//  Copyright © 2018 SquaredDimesions. All rights reserved.
//

#import "WebDataManager.h"

@interface WebDataManager () <NSXMLParserDelegate>

@property(nonatomic, strong) NSMutableArray * metaData;
@property(nonatomic, strong) NSString *strAuthor;
@property(nonatomic, strong) NSString *strDate;
@property(nonatomic, strong) NSString *strTitle;
@property(nonatomic, strong) NSString *strURL;
@property(nonatomic, strong) NSString *strLastStartedElementName;
@property(nonatomic, strong) NSString *strHTMLContent;

@property(nonatomic, strong) NSXMLParser *parser;

@end

@implementation WebDataManager

- (void) extractDataFromURL:(NSString *)strUrl
{
    NSString *urlString = strUrl;
    NSError *error;
    
    
    NSURL *myURL = [NSURL URLWithString:urlString];
    NSString *myHTMLString = [NSString stringWithContentsOfURL:myURL encoding: NSISOLatin1StringEncoding error:&error];
    
    if (error != nil)
    {
        NSLog(@"Error : %@", error);
        
        if(self.delegate != nil){
            if([self.delegate respondsToSelector:@selector(didExtractedDataFromURL:dictionary:)]) {
                [self.delegate didExtractedDataFromURL:self dictionary:nil];
            }
        }
    }
    else
    {
        NSLog(@"HTML : %@", myHTMLString);
        self.strHTMLContent = myHTMLString;
        self.strURL = urlString;
        self.parser = [[NSXMLParser alloc] initWithData:[myHTMLString dataUsingEncoding:NSISOLatin1StringEncoding]];
        
        [self.parser setDelegate:self];
        
        [self.parser parse];
    }
}
#pragma mark - NSXMLParser delegates

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
   attributes:(NSDictionary *)attributeDict
{
    
    NSLog(@"Element Name : %@ ", elementName);
    NSLog(@"Attributes : %@ ", attributeDict);
    
    if([elementName isEqualToString:@"meta"]){
        
        NSString *strValue = [attributeDict objectForKey:@"name"];
        
        if(self.strAuthor == nil || self.strAuthor.length == 0){
            if([strValue containsString:@"author"]){
                
                NSString *strContentVal = [attributeDict objectForKey:@"content"];
                self.strAuthor = strContentVal;
            }
        }
        if(self.strDate == nil || self.strDate.length == 0){
            if([strValue containsString:@"date"]){
                
                NSString *strContentVal = [attributeDict objectForKey:@"content"];
                self.strDate = strContentVal;
            }
        }
    }
    
    self.strLastStartedElementName = elementName;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    if([self.strLastStartedElementName isEqualToString:@"title"]){
        
        if(self.strTitle == nil || self.strTitle.length == 0) {
            self.strTitle = string;
        }
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if(self.strAuthor != nil && self.strDate != nil && self.strTitle != nil){
        [self.parser abortParsing];
    }
}
- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self xmlParsingFinished];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self xmlParsingFinished];
}

-(void) xmlParsingFinished
{
    // Here you can do your functions.
    // If you receive multiple tags from the webservice here you load the values in your UITableView in here.
    
    NSMutableDictionary *respData = [[NSMutableDictionary alloc] init];
    
    [respData setObject:self.strURL forKey:@"url"];
    
    
    
    if(self.strTitle != nil){
        [respData setObject:self.strTitle forKey:@"title"];
    }
    else{
        [respData setObject:[self extractTitle] forKey:@"title"];
    }
    
    if(self.strAuthor != nil){
        [respData setObject:self.strAuthor forKey:@"author"];
    }
    else{
        [respData setObject:[self extractAuthorName] forKey:@"author"];
    }
    
    if(self.strDate != nil)
        [respData setObject:self.strDate forKey:@"date"];
    
    if(self.delegate != nil){
        if([self.delegate respondsToSelector:@selector(didExtractedDataFromURL:dictionary:)]) {
            [self.delegate didExtractedDataFromURL:self dictionary:respData];
        }
    }
}

- (NSString *) extractAuthorName
{
    NSArray *metas = [self.strHTMLContent componentsSeparatedByString:@"<meta"];
    
    for (int i = 0; i < metas.count; ++i) {
        
        NSString *strMeta = [metas objectAtIndex:i];
        
        if([strMeta containsString:@"name=\"parsely-author\""]){
            if([strMeta containsString:@"content="]){
                NSRange range = [strMeta rangeOfString:@"content="];
                if(range.location != NSNotFound) {
                    NSString *subStr = [strMeta substringFromIndex:range.location+9];
                    range = [subStr rangeOfString:@"/"];
                    if(range.location != NSNotFound) {
                        subStr = [subStr substringToIndex:range.location-1];
                        
                        return subStr;
                    }
                    
                }
            }
        }
        
    }
    
    return @"";
}

- (NSString *) extractTitle
{
    
    NSRange range = [self.strHTMLContent rangeOfString:@"<title>"];
    if(range.location != NSNotFound) {
        NSString *subStr = [self.strHTMLContent substringFromIndex:range.location+7];
        range = [subStr rangeOfString:@"</title>"];
        if(range.location != NSNotFound) {
            subStr = [subStr substringToIndex:range.location];
            return subStr;
        }
    }
    return @"";
}

@end
