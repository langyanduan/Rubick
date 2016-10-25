# Auto Layout DSL


## Layout

```
activateLayoutConstraints([
    view1.left == view2,
    view1.right == view2,
    view1.top == view.bottom,
    view1.width == 30
])
```

or

```
activateLayoutConstraints(view1, view2) { (view1, view2) in [
    view1.left == view2,
    view1.right == view2,
    view1.top == view.bottom,
    view1.width == 30
]}
```

more

```
activateLayoutConstraints(view1, view2) { (view1, view2) in [
    view1.edges == view2.insets(top: 5, left: 0, bottom: 5, right: 0)
]}
```


## Line Layout

H: | - 5 - view1(=10) - 20 - view2(<=15) - view3(=view2) - view4 - (>=50) - view5 - |


```
activateLineLayout(head: contentView.dsl.left, tail: contentView.dsl.right, axis: .horizontal, options: [], items: [
    ==5, view1 == 10, ==20, view2 <= 15, view3 == view2, view4, >=50, view5
])
```

or

```
activateLineLayout(in: contentView, axis: .horizontal, options: [], items: [
    ==5, view1 == 10, ==20, view2 <= 15, view3 == view2, view4, >=50, view5
])
```

or 

```
activateHorizontalLayout(in: contentView, options: [], items: [
    ==5, view1 == 10, ==20, view2 <= 15, view3 == view2, view4, >=50, view5
])
```

About `option`

when axis is horizontal, `head`, `center`, `tail` means `top`, `centerY`, `bottom`, otherwise means `left`, `centerX`, `right`


if `view1`~`view5` aligh top to contentView,

`options` should be

``` 
let options: LineLayoutOption = [
    .alignHead(to: contentView)
]
```

other option

```
let options: LineLayoutOption = [
    .heightEqual(to: 30),
    .widthEqual(to: otherView)
]
```