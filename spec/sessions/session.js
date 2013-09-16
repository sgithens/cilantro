define(['jquery', 'cilantro/session'], function($, session) {

    describe('Session', function() {

        var s;

        beforeEach(function() {
            s = new session.Session({
                url: '/mock/root.json'
            });
        });

        it('initial state', function() {
            expect(s.get('url')).toBe('/mock/root.json');
            expect(s.isValid()).toBe(true);
            expect(s.opened).toBe(false);
            expect(s.loading).toBe(false);
            expect(s.started).toBe(false);
        });

        it('open', function() {
            s.open();
            expect(s.loading).toBe(true);

            waitsFor(function() {
                return s.opened;
            }, 100);

            runs(function() {
                expect(s.loading).toBe(false);
                expect(s.opened).toBe(true);
                expect(s.response).toBeDefined();
                expect(s.error).toBeUndefined();
                expect(s.title).toBeDefined();
                expect(s.version).toBeDefined();
                expect(s.data).toBeDefined();
                for (var key in s.data) {
                    expect(s.data[key].url).toBeDefined();
                }
                expect(s.router).toBeDefined();
            });
        });

        it('start', function() {
            s.open();
            waitsFor(function() {
                return s.opened;
            }, 100);

            runs(function() {
                s.start();
            });
        });

    });

});
