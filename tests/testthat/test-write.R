context("write_csv")

test_that("strings are only quoted if needed", {
  x <- c("a", ',')

  csv <- write_csv(data.frame(x), "", col_names = FALSE)
  expect_equal(csv, 'a\n","\n')
})

test_that("read_csv and write_csv round trip special chars", {
  x <- c("a", '"', ",", "\n")

  output <- data.frame(x)
  input <- read_csv(write_csv(output, ""))

  expect_equal(input$x, x)
})

test_that("roundtrip preserved floating point numbers", {
  input <- data.frame(x = runif(100))
  output <- read_csv(write_csv(input, ""))

  expect_equal(input$x, output$x)
})

test_that("roundtrip preserves dates and datetimes", {
  x <- as.Date("2010-01-01") + 1:10
  y <- as.POSIXct(x)
  attr(y, "tzone") <- "UTC"

  input <- data.frame(x, y)
  output <- read_csv(write_csv(input, ""))

  expect_equal(output$x, x)
  expect_equal(output$y, y)
})
