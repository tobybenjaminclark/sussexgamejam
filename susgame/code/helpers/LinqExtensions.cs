using System.Collections.Generic;

namespace System.Linq
{

    public static class LinqExtensions
    {

        public static void ForEach<T>(this IEnumerable<T> source, Action<T> functor)
        {
            // Yes this does a copy, this was modified to be safer since we don't care too much about performance here
            foreach (var item in source.ToArray())
            {
                functor(item);
            }
        }

        public static T Pick<T>(this IList<T> source)
        {
            return source[Random.Shared.Next(0, source.Count)];
        }

        public static T Pick<T>(this ICollection<T> source)
        {
            return source.ElementAt(Random.Shared.Next(0, source.Count));
        }

        public static T Pick<T>(this IEnumerable<T> source)
        {
            return source.ElementAt(Random.Shared.Next(0, source.Count()));
        }

        public static T PickWeight<T>(this IEnumerable<T> source, Func<T, float> weightGenerator)
        {
            // Prevent multi-enumeration by iterating through the enumable a single time first
            var compiled = source.ToList();
            float totalWeight = compiled.Sum(weightGenerator);
            float selectedValue = Random.Shared.NextSingle() * totalWeight;
            foreach (var value in compiled)
            {
                selectedValue -= weightGenerator(value);
                if (selectedValue <= 0)
                {
                    return value;
                }
            }
            if (compiled.Count == 0)
            {
                throw new IndexOutOfRangeException("Attempting to pick weight on an enumerable collection that has no elements.");
            }
            return compiled[compiled.Count - 1];
        }

        public static T MinBy<T, U>(this IEnumerable<T> source, Func<T, U> comparator)
            where U : IComparable
        {
            var enumerator = source.GetEnumerator();
            if (!enumerator.MoveNext())
                return default;
            var best = enumerator.Current;
            var score = comparator(best);
            while (enumerator.MoveNext())
            {
                var currentScore = comparator(enumerator.Current);
                if (currentScore.CompareTo(score) < 0)
                {
                    best = enumerator.Current;
                    score = currentScore;
                }
            }
            return best;
        }

        public static T MaxBy<T, U>(this IEnumerable<T> source, Func<T, U> comparator)
            where U : IComparable
        {
            var enumerator = source.GetEnumerator();
            if (!enumerator.MoveNext())
                return default;
            var best = enumerator.Current;
            var score = comparator(best);
            while (enumerator.MoveNext())
            {
                var currentScore = comparator(enumerator.Current);
                if (currentScore.CompareTo(score) > 0)
                {
                    best = enumerator.Current;
                    score = currentScore;
                }
            }
            return best;
        }

        public static IEnumerable<(int, T)> Indexed<T>(this IEnumerable<T> source)
        {
            var enumerator = source.GetEnumerator();
            for (int i = 0; enumerator.MoveNext(); i++)
            {
                yield return (i, enumerator.Current);
            }
        }

        public static bool Contains<T>(this IEnumerable<T> source, T value, out int index)
        {
            index = -1;
            var enumerator = source.GetEnumerator();
            if (!enumerator.MoveNext())
                return false;
            for (int i = 0; enumerator.MoveNext(); i++)
            {
                if (enumerator.Current.Equals(value))
                {
                    index = i;
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// Returns source if it isn't empty, otherwise returns second.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="source"></param>
        /// <param name="second"></param>
        /// <returns></returns>
        public static IEnumerable<T> Else<T>(this IEnumerable<T> source, IEnumerable<T> second)
        {
            var firstEnumerator = source.GetEnumerator();
            if (!firstEnumerator.MoveNext())
            {
                foreach (var secondItem in second)
                    yield return secondItem;
                yield break;
            }
            yield return firstEnumerator.Current;
            while (firstEnumerator.MoveNext())
            {
                yield return firstEnumerator.Current;
            }
        }

        public static IEnumerable<T> Except<T>(this IEnumerable<T> source, T excludedValue)
        {
            foreach (var item in source)
            {
                if (item?.Equals(excludedValue) ?? (excludedValue == null))
                    continue;
                yield return item;
            }
        }

    }

}