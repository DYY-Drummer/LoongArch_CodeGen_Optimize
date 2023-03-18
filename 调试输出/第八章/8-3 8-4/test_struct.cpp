struct Date
{
    int year;
    int month;
    int day;
};
Date today = {2023, 3, 18};

Date getDate()
{
    return today;
}

Date copyDate_byVal(Date date)
{
    return date;
}

Date copyDate_byPointer(Date* date)
{
    return *date;
}

int test_struct()
{
    Date date1 = getDate();
    Date date2 = copyDate_byVal(date1);
    Date date3 = copyDate_byPointer(&date1);
    if (!(date1.year == 2023 && date1.month == 3 && date1.day == 18 ))
        return 1;
    if (!(date2.year == 2023 && date2.month == 3 && date2.day == 18 ))
        return 1;

    return 0;
}
