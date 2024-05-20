# Phone Call Billing Exercise

This exercise was completed using the CuisUniversity environment to code in SmallTalk.

## Packages Used

- **GregorianCalendar Model**: For handling dates and times, I used the GregorianCalendar model from the Chalten package.
  - [A Point-Based Model of the Gregorian Calendar](https://www.dropbox.com/s/kjczqs05jk9olk7/article.pdf?e=1&dl=0)

## Assumptions

- **Time Zones**: Calls only take place within one time zone. This means there cannot be a call that begins in one price range and ends in another.

## Testing

- **Test-Driven Development (TDD)**: I used TDD to ensure the accuracy of total values for the bills.

## Future Improvements

- **Call Class**: Refactor the `Call` instance creation method to handle call durations without the restriction of the `withDurationInMinutes:` parameter (the unit shouldn't be mentioned on the message name).

- **Pricing Implementation**: The current implementation for determining national and international call prices uses a `Dictionary` with symbols for the locations as keys (e.g., `#Uruguay`) and values as the price per minute (e.g., `1*peso`) and probably this implementation could be improved.
