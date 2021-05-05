# get the csv file in
# isolate the column
# split it
# keep the first 3 only (?)

import pandas as pd

df = pd.read_csv(
    r"D:\Google Drive\Uni\Tilburg\Semester 6\Interactive Information Visualization\Group Project\IMDb movies.csv",
    low_memory=False)
# print(df.head(10))

dfFull = pd.concat([df, df["genre"].str.split(', ', expand=True)], axis=1)
dfFinal = dfFull.drop(['imdb_title_id', "title",
             'original_title', "genre",
             'date_published', 'duration',
             'country', 'language',
             'director', 'writer',
             'production_company', 'actors',
             'description',
             'votes', 'budget',
             'usa_gross_income', 'worlwide_gross_income',
             'metascore', 'reviews_from_users',
             'reviews_from_critics'],
            axis=1, inplace=False)
print(dfFinal.columns)
dfFinal.columns = ["year", "avg_vote", "genre_1", "genre_2", "genre_2"]
dfFinal.to_csv("dataPreprocessed.csv")
