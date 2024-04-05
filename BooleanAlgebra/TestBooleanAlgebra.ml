module TestBooleanAlgebra (BA : IBooleanAlgebra) = struct
    let testOrCommunitativity a b =
        let x = BA.or_ a b in
        let y = BA.or_ b a in
        assert (x = y)

    let testAndCommunitativity a b =
        let x = BA.and_ a b in
        let y = BA.and_ b a in
        assert (x = y)

    let testOrDistributivity a b c =
        let x = BA.or_ a (BA.and_ b c) in
        let y = BA.and_ (BA.or_ a b) (BA.or_ a c) in
        assert (x = y)

    let testAndDistributivity a b c =
        let x = BA.and_ a (BA.or_ b c) in
        let y = BA.or_ (BA.and_ a b) (BA.and_ a c) in
        assert (x = y)

    let testOrIdentity a =
        let x = BA.or_ a (BA.or_identity) in
        assert (a = x)

    let testAndIdentity a =
        let x = BA.and_ a (BA.and_identity) in
        assert (a = x)

    let testOrInverse a =
        let x = BA.or_ a (BA.not_ a) in
        assert (x = BA.and_identity)

    let testAndInverse a =
        let x = BA.and_ a (BA.not_ a) in
        assert (x = BA.or_identity)

    let testIdentitiesDiff () =
        let x = BA.and_identity in
        let y = BA.or_identity in
        assert (x <> y)

    let testAll a b c =
        testOrCommunitativity a b;
        testAndCommunitativity a b;
        testOrDistributivity a b c;
        testAndDistributivity a b c;
        testOrIdentity a;
        testAndIdentity a;
        testOrInverse a;
        testAndInverse a;
        testIdentitiesDiff ()

end
