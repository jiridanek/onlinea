package table

import (
	"github.com/llgcode/draw2d/draw2dimg"
	"image"
	"image/draw"

	"image/color"
	"image/png"
	"io"
	"math"
)

var _ = draw.Draw

type Drawer interface {
	Draw()
	Measure() image.Point
}

type Layouter interface {
}

type Drawable struct {
	layout   Layouter
	children []*Drawer
}

func DrawTable(w io.Writer) {
	img := image.NewRGBA(image.Rect(0, 0, 640, 480))

	//	draw.Draw(img, img.Rect, &image.Uniform{color.RGBA{6, 6, 100, 255}}, image.ZP, draw.Src)

	gc := draw2dimg.NewGraphicContext(img)

	gc.SetStrokeColor(color.RGBA{0x44, 0x44, 0x44, 0xff})
	gc.SetLineWidth(5)
	//
	gc.MoveTo(50, 50)
	//gc.LineTo(400, 50)
	gc.ArcTo(400, 90, 40, 40, math.Pi, 0.5*math.Pi)
	gc.Close()
	gc.FillStroke()

	//	gc.SetFillColor(color.RGBA{0x44, 0xff, 0x44, 0xff})
	//	gc.SetStrokeColor(color.RGBA{0x44, 0x44, 0x44, 0xff})
	//	gc.SetLineWidth(5)
	//
	//	// Draw a closed shape
	//	gc.MoveTo(10, 10) // should always be called first for a new path
	//	gc.LineTo(100, 50)
	//	gc.QuadCurveTo(100, 10, 10, 10)
	//	gc.Close()
	//	gc.FillStroke()

	png.Encode(w, img)
}
