#ifndef SPHERE_H
#define SPHERE_H

#include "hittable.h"
#include "vec3.h"

class sphere : public hittable
{
public:
	sphere() {}
	sphere(point3 cen, double r) : center(cen), radius(r) {}
	virtual bool hit(const ray& r, double t_min, double t_max, hit_record& rec) const;
public:
	point3 center;
	double radius;
};

bool sphere::hit(const ray& r, double t_min, double t_max, hit_record& rec) const
{
	vec3 oc = r.origin() - center;
	double a = r.direction().length_squared();
	double half_b = dot(oc, r.direction());
	double c = oc.length_squared() - radius*radius;
	double discriminant = half_b*half_b - a*c;
	if(discriminant > 0)
	{
		double root = sqrt(discriminant);
		double temp = (-half_b - root) / a;
		if(temp < t_max && temp > t_min)
		{
			rec.t = temp;
			rec.p = r.at(rec.t);
			vec3 outward_normal = (rec.p - center) / radius;
			rec.normal = outward_normal;
			return true;
		}
		temp = (-half_b + root) / a;
		if(temp < t_max && temp > t_min)
		{
			rec.t = temp;
			rec.p = r.at(rec.t);
			rec.normal = (rec.p - center) / radius;
			return true;
		}
	}
	return false;
}

#endif