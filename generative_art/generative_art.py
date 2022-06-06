from PIL import Image, ImageDraw
from random import randint



def generate_number():
    return randint(0,255)

def Average(l):
    return sum(l) // len(l)

def generate_art():
    scale_factor = 2
    target_size = 400
    image_size = 255 *scale_factor
    padding_canvas = 30 *scale_factor
    numberimages = 50
    # data to be retrieved for JSON metadata file
    num_lines = [] # this returns a list of the number of lines for each image
    l_bg_color = [] # this returns a list of the bg color for each image
    l_line_color = [[] for i in range(numberimages)] # this returns a list of the min/max color for each image
    for numberimage in range(numberimages):
        bg_color = (generate_number(),generate_number(),generate_number())
        l_bg_color.append(bg_color)

        number_points = randint(10,40)
        num_lines.append(number_points)

        image = Image.new(
            "RGB",
            size=(image_size,image_size),
            color= bg_color
            )
        draw = ImageDraw.Draw(image)
        points = []
        for _ in range(number_points):
            point_xy = (randint(padding_canvas,image_size-padding_canvas), randint(40,image_size-padding_canvas))
            r_point = point_xy
            points.append(r_point)

        for i, point in enumerate(points):
            p1 = point
            if i == len(points)-1:
                p2 = points[0]
            else : p2 = points[i+1]
            line_xy = (p1,p2) # a line consists of two points
            color_line = (generate_number(),generate_number(),generate_number())
            l_line_color[numberimage].append(color_line)
            thickness = (randint(1,15)*scale_factor)
            draw.line(line_xy, fill=color_line, width=thickness) 

        image = image.resize((target_size,target_size), resample=Image.ANTIALIAS)
        image.save(f"images\\{numberimage + 1}.jpeg")


    for i in range(len(l_line_color)): # for getting a tuple (min, max)
        l_line_color[i] = (min(l_line_color[i]),max(l_line_color[i]))

    data = [num_lines, l_bg_color, l_line_color]
    print(data)
    return data      


if __name__ == "__main__":
   generate_art()

