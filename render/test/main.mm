#import <Foundation/Foundation.h>
#import <string>

#define STB_IMAGE_WRITE_IMPLEMENTATION
#define STBI_ONLY_PNG
#import "../lunasvg/example/stb_image_write.h"
#import "../lunasvg/include/lunasvg.h"

void Quad(NSMutableString *svg, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) {
    [svg appendString:[NSString stringWithFormat:@"<polyline points=\"%d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d\" />",x1,y1,x2,y2,x2,y2,x3,y3,x3,y3,x4,y4,x4,y4,x1,y1]];

}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        int W = 1920;
        int H = 1080;
                
        NSString *setting = [NSString stringWithFormat:@"<svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"0px\" y=\"0px\" viewBox=\"0 0 %d %d\" style=\"enable-background:new 0 0 %d %d;\" xml:space=\"preserve\"><rect x=\"0\" y=\"0\" width=\"%d\" height=\"%d\" fill=\"none\" stroke=\"none\" />",W,H,W,H,W,H];
        
        NSMutableString *svg = [NSMutableString stringWithCapacity:0];
        [svg appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
        [svg appendString:setting];
        
        [svg appendString:@"<g fill=\"#00F\">"];

        int cx = W>>1;
        int cy = H>>1;
        
        Quad(svg,cx-200,cy-200,cx+200,cy-200,cx+200,cy+200,cx-200,cy+200);
                    
        [svg appendString:@"</g>"];
        [svg appendString:@"</svg>"];
        
        [svg writeToFile:@"../../../assets/test.svg" atomically:YES encoding:NSUTF8StringEncoding error:nil];

        
        std::string str = [svg UTF8String];
        std::unique_ptr<lunasvg::Document> document = lunasvg::Document::loadFromData(str);
        lunasvg::Bitmap bitmap = document->renderToBitmap();

        bitmap.convertToRGBA();
        stbi_write_png("../../../assets/test.png",int(bitmap.width()),int(bitmap.height()),4, bitmap.data(),0);

    }
    return 0;
}
